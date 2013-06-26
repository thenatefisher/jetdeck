require 'bcrypt'

class User < ActiveRecord::Base

  attr_accessor  :password, :password_confirmation

  before_save :encrypt_password
  before_create :set_defaults

  has_many :todos, :foreign_key => "created_by", :dependent => :destroy
  has_many :airframes, :foreign_key => "created_by", :dependent => :destroy
  has_many :contacts, :class_name => 'Contact', :foreign_key => "created_by", :dependent => :destroy
  has_many :airframe_specs, :class_name => 'AirframeSpec', :foreign_key => "created_by"
  has_many :airframe_images, :class_name => 'AirframeImage', :foreign_key => "created_by"

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
    (self.storage_usage > self.storage_quota)
  end

  private

    def set_defaults

      # in bytes, set storage quota to 100Mb if not mass assigned
      self.storage_quota ||= 104857600

      # set 10 invites if not mass assigned
      self.invites ||= 10

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

end
