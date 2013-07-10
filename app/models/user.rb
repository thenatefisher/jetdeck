require "bcrypt"

class User < ActiveRecord::Base

  attr_accessor  :password, :password_confirmation, :storage_quota, :airframes_quota

  before_save :encrypt_password
  before_create :set_defaults

  has_many :todos, :foreign_key => "created_by", :dependent => :destroy
  has_many :airframes, :foreign_key => "created_by", :dependent => :destroy
  has_many :contacts, :class_name => "Contact", :foreign_key => "created_by", :dependent => :destroy
  has_many :airframe_specs, :class_name => "AirframeSpec", :foreign_key => "created_by", :dependent => :destroy
  has_many :airframe_images, :class_name => "AirframeImage", :foreign_key => "created_by", :dependent => :destroy
  has_many :invites, :class_name => "Invite", :foreign_key => "created_by"

  has_many :messages_sent,
    :class_name => "AirframeMessage",
    :foreign_key => "created_by", 
    :dependent => :destroy

  belongs_to :contact, :dependent => :destroy
  validates_associated :contact
  validates_presence_of :contact
  validates_uniqueness_of :contact_id

  validates_presence_of :password, :on => :create
  validates_presence_of :password, :if => "password_confirmation.present?",
    :message => "Password does not match confirmation"
  validates_presence_of :password_confirmation, :on => :password_changed?, :if => "password.present?"
  validates_confirmation_of :password, :on => :update,
    :message => "Password does not match confirmation",
    :if => "password.present?"
  validates :password, :length =>
    { :minimum => 6, :message => "Password must be at least 6 chars" },
    :if => "password.present?"

  # set subscription plan attributes
  @@bytes_in_gigabyte          = 1073741824
  @@pro_storage_quota          = @@bytes_in_gigabyte*30
  @@standard_storage_quota     = @@bytes_in_gigabyte*10
  @@trial_storage_quota        = @@bytes_in_gigabyte
  @@pro_airframes_quota        = 0
  @@standard_airframes_quota   = 20
  @@trial_airframes_quota      = 5
  @@trial_length               = 14.days

  def storage_usage
    specs = self.airframe_specs.reduce(0){|sum, spec| sum += spec.spec_file_size}
    images = self.airframe_images.reduce(0){|sum, image| sum += image.image_file_size}
    (images+specs)
  end

  def over_storage_quota?
    (self.storage_usage >= self.storage_quota)
  end

  def over_airframes_quota?
    # airframes_quota = 0 indicates unlimitd
    (self.airframes_quota > 0) ? (self.airframes.count >= self.airframes_quota) : false
  end

  def trial_time_remaining
    # trial time remaining in days
    # nil if not in a trial
    time_left = ((self.subscription_trial_end - self.created_at)/3600/24).round
    if (self.plan == "Trial" && time_left >= 0) 
      time_left
    else
      nil
    end
  end

  def standard_plan_available?
    # if user is pro and has under the standard plan usage, he can downgrade
    (self.airframes.count <= @@standard_airframes_quota &&
        self.storage_usage <= @@standard_storage_quota)
  end

  def delinquent?
    if self.trial_time_remaining.present?
      return false
    else
      (self.status != 'active' && self.status != 'past_due') 
    end
  end

  def status 
    self.subscription_status
  end

  def plan
    self.subscription_plan
  end

  def change_plan(newplan)
    begin
      # get stripe customer record and attempt to change plan type
      stripe_customer = self.stripe
      stripe_customer.update_subscription(:plan => newplan.upcase, :prorate => true)
      # if it worked, change the local user record to match
      self.subscription_plan = stripe_customer.subscription.plan.name
      self.subscription_status = stripe_customer.subscription.status
      # save
      return self.save!
    rescue => error 
      logger.warn error.message
      return false
    end
  end

  def cancel(delete_data=false)
    begin
      stripe_customer = self.stripe
      stripe_customer.cancel_subscription
      self.subscription_status = stripe_customer.subscription.status
    rescue
      return false
    end
      self.enabled = false
      return self.destroy if delete_data
      return self.save!
  end

  def airframes_quota
    case self.subscription_plan.upcase
      when "PRO"
        # unlimited airframes quota 
        return @@pro_airframes_quota
      when "STANDARD"
        # assign airframes quota 
        return @@standard_airframes_quota
      else
        # assign airframes quota to initial free trial limit
        return @@trial_airframes_quota
    end
  end

  def storage_quota
    case self.subscription_plan.upcase
      when "PRO"
        # in bytes, set storage quota to 30Gb 
        return @@pro_storage_quota
      when "STANDARD"
        # in bytes, set storage quota to 10Gb 
        return @@standard_storage_quota
      else
        # in bytes, set storage quota to 1Gb 
        return @@trial_storage_quota
    end
  end

  def stripe
    @stripe = Stripe::Customer.retrieve(self.stripe_id) rescue nil if @stripe.blank?
    @stripe = nil if @stripe.deleted rescue @stripe
    return @stripe
  end

  def warnings
    warnings = Hash.new

    if !self.activated
      warnings[:message] = "Please activate your account to send emails."
      warnings[:type] = "activate"
    elsif ((self.storage_usage / self.storage_quota) > 0.90)
      warnings[:message] = "Want more file storage?"
      warnings[:type] = "upgrade"
    elsif (self.airframes_quota > 0) && ((self.airframes.count / self.airframes_quota) > 0.90)
      warnings[:message] = "Need to add more aircraft?"
      warnings[:type] = "upgrade"
    elsif self.plan == "Trial" && self.trial_time_remaining.nil?
      warnings[:message] = "Your free trial has expired!"
      warnings[:type] = "upgrade"
    elsif self.plan == "Trial" && self.trial_time_remaining == 0
      warnings[:message] = "This is the last day of your free trial!"
      warnings[:type] = "upgrade"
    elsif self.plan == "Trial" && (self.trial_time_remaining.present? && self.trial_time_remaining < 6)
      warnings[:message] = "Only #{self.trial_time_remaining} days left on your free trial!"
      warnings[:type] = "upgrade"
    end

    return warnings
  end

  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    user = User.find(:first, :include => :contact,
                     :conditions => ["enabled = true AND lower(contacts.email) = ?", email.downcase])
    if user.present? && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private

  def set_defaults

    # set 10 invites if not mass assigned
    self.invites_available ||= 10

    # default tutorial enabled status 
    self.help_enabled = true

    # default to enabled status 
    self.enabled = true

    # default to not activated
    self.activated = false

    # generate auth token
    generate_token(:auth_token)

    # generate activation token
    generate_token(:activation_token)

    # generate activation token
    generate_token(:bookmarklet_token)

    # create stripe account
    customer = Stripe::Customer.create(
      :email => self.contact.email
    )
    self.stripe_id = customer.id rescue nil

    # set trial start
    self.subscription_plan = "Trial"
    self.subscription_trial_end = Time.now() + @@trial_length

    # seed account with sample records

    return true
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end
