require 'bcrypt'

class User < ActiveRecord::Base

  has_many :actions, :foreign_key => "created_by"
  
  has_one :logo, :class_name => "UserLogo", :foreign_key => "user_id"

  attr_accessible :password,
                  :password_confirmation,
                  :contact,
                  :contact_id,
                  :airframes,
                  :active

  attr_accessor  :password, :password_confirmation

  before_save :encrypt_password
  
  before_create { set_defaults() }

  has_many :logins
  
  has_many :airframes, :dependent => :destroy

  has_many :contacts, :class_name => 'Contact', :foreign_key => "owner_id"
  
  belongs_to :contact, :dependent => :destroy

  validates_uniqueness_of :contact_id
  
  validates_presence_of :contact_id
  
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

  def set_defaults()

    # set 10 invites
    self.invites = 10

    # default to active status
    self.active ||= true
    
    # default to not activated
    self.activated = false

    # generate auth token
    generate_token(:auth_token)

    # generate activation token
    generate_token(:activation_token)
    
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
    contact = Contact.find(:first, :conditions =>
      ["lower(email) = ? AND owner_id is null", email.downcase])
    user = User.where(:contact_id => contact.id, :active => true).first if contact
    if user && 
      user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
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
