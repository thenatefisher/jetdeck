require 'bcrypt'

class User < ActiveRecord::Base

  has_one :logo, :class_name => "UserLogo", :foreign_key => "user_id"

  attr_accessible :password,
                  :password_confirmation,
                  :contact,
                  :contact_id,
                  :airframes,
                  :active

  attr_accessor  :password, :password_confirmation

  before_save :encrypt_password
  before_create { set_defaults(:auth_token) }

  has_many :logins
  has_many :airframes, :dependent => :destroy

  has_many :contacts, :class_name => 'Contact', :foreign_key => "owner_id"
  belongs_to :contact, :dependent => :destroy

  #has_secure_password
  #force_ssl

  validates_uniqueness_of :contact_id
  validates_presence_of :contact_id
  validates_presence_of :password, :on => :create
  
  if defined? password
      validates_presence_of :password_confirmation, :on => [:update, :create]
      validates_confirmation_of :password, :on => [:update, :create]
  end

  def set_defaults(paramName)

    # default to active status
    self.active ||= true

    # generate auth token
    begin
        self[paramName] = SecureRandom.urlsafe_base64
    end while User.exists?(paramName => self[paramName])

  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def encrypt_password
    if defined? password && password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password)
    contact = Contact.find_by_email(email)
    user = User.where(:contact_id => contact, :active => true).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
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
