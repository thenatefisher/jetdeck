require "bcrypt"

class User < ActiveRecord::Base

  attr_accessor  :password, :password_confirmation

  before_save :encrypt_password
  before_create :set_defaults

  has_many :todos, :foreign_key => "created_by", :dependent => :destroy
  has_many :airframes, :foreign_key => "created_by", :dependent => :destroy
  has_many :contacts, :class_name => "Contact", :foreign_key => "created_by", :dependent => :destroy
  has_many :airframe_specs, :class_name => "AirframeSpec", :foreign_key => "created_by"
  has_many :airframe_images, :class_name => "AirframeImage", :foreign_key => "created_by"
  has_many :invites, :class_name => "Invite", :foreign_key => "created_by"

  has_many :messages_sent,
    :class_name => "AirframeMessage",
    :foreign_key => "created_by"

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

  def storage_usage
    specs = self.airframe_specs.reduce(0){|sum, spec| sum += spec.spec_file_size}
    images = self.airframe_images.reduce(0){|sum, image| sum += image.image_file_size}
    images+specs
  end

  def over_storage_quota?
    (self.storage_usage >= (self.storage_quota * 1048576))
  end

  def over_airframes_quota?
    # airframes_quota = 0 indicates unlimitd
    (self.airframes_quota > 0) ? (self.airframes.count >= self.airframes_quota) : false
  end

  def trial_time_remaining
    # check stripe account type first
    plan = (self.stripe.subscription.plan.name.present? && self.stripe.subscription.status == "active") rescue false
    interval = (((User.first.created_at+14.days)-Time.now)/3600/24).round
    interval = 0 if interval < 0
    return interval if !plan else nil
  end

  def stripe
    Stripe::Customer.retrieve(self.stripe_id) rescue nil
  end

  def warnings
    warnings = Hash.new

    if !self.activated
      warnings[:message] = "Please activate your account to send emails."
      warnings[:type] = "activate"
    elsif self.over_storage_quota?
      warnings[:message] = "Want more file storage?"
      warnings[:type] = "upgrade"
    elsif self.over_airframes_quota?
      warnings[:message] = "Need to add more aircraft?"
      warnings[:type] = "upgrade"
    elsif self.trial_time_remaining.present? && self.trial_time_remaining == 0
      warnings[:message] = "Your free trial has expired!"
      warnings[:type] = "upgrade"
    elsif self.trial_time_remaining.present? && self.trial_time_remaining < 6
      warnings[:message] = "Only #{self.trial_time_remaining} days left on your free trial!"
      warnings[:type] = "upgrade"
    end

    return warnings
  end

  def set_defaults

    # set quotas
    self.update_account_quotas

    # set 10 invites if not mass assigned
    self.invites_quota ||= 10

    # default tutorial enabled status if not mass assigned
    self.help_enabled ||= true

    # default to enabled status if not mass assigned
    self.enabled ||= true

    # default to not activated
    self.activated ||= false

    # generate auth token
    generate_token(:auth_token)

    # generate activation token
    generate_token(:activation_token)

    # generate activation token
    generate_token(:bookmarklet_token)

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

  def update_account_quotas

    plan = self.stripe.subscription.plan.name if self.stripe.subscription.status == "active" rescue false

    case plan
      when "Pro"
        # in bytes, set storage quota to 30Gb 
        self.storage_quota = 30720
        # unlimited airframes quota 
        self.airframes_quota = 0
      when "Standard"
        # in bytes, set storage quota to 10Gb 
        self.storage_quota = 10240
        # assign airframes quota 
        self.airframes_quota = 20
      else
        # in bytes, set storage quota to 1Gb 
        self.storage_quota = 1024
        # assign airframes quota to initial free trial limit
        self.airframes_quota = 5
    end

    self.save!
    return self
  end

  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    user = User.find(:first, :include => :contact,
                     :conditions => ["enabled = true AND lower(contacts.email) = ?", email.downcase])
    if user.present? && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user.update_account_quotas
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

end
