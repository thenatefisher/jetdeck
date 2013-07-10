class Invite < ActiveRecord::Base

  belongs_to :sender, :class_name => "User", :foreign_key => "created_by"
  validates_presence_of :sender

  validates_presence_of :email
  validates_format_of :email,
    :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
    :message => "email address is invalid"

  before_create :init
  validate :check_invite_valid

  def init

    # not used yet
    self.activated = false

    ## Create Token
    self.token = BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, "").last(7)
    while (Invite.where(:token => self.token).count > 0)
      self.token = BCrypt::Engine.generate_salt.gsub(/[^a-zA-Z0-9]+/, "").last(7)
    end

  end

  def check_invite_valid
    # dont create the invite if a user already exists
    if User.find(:first, :include => :contact,
                 :conditions => ["lower(contacts.email) = ?", self.email.downcase]).present?
      self.errors.add(:email, "already has a JetDeck account")
      return false
    end

    # does user still have invites to use?
    if self.sender.invites_available < 1
      self.errors.add(:sender, "No invites remaining")
      return false
    end

    # is user activated?
    if !self.sender.activated
      self.errors.add(:base, "Invites disabled pending <a href='/profile'>account verification</a>.")
      return false
    end
  end

end
