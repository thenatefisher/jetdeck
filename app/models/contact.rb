class Contact < ActiveRecord::Base

  attr_accessible :phone, :sticky_id, :notes, :todos,
    :first, :last, :email, :email_confirmation, :company,
    :title, :description, :website

  has_many :todos, :foreign_key => :actionable_id, :as => :actionable, :dependent => :destroy
  accepts_nested_attributes_for :todos

  has_many :notes, :as => :notable, :dependent => :destroy
  accepts_nested_attributes_for :notes

  has_many :messages_received,
    :class_name => "AirframeMessage",
    :foreign_key => "recipient_id",
    :dependent => :destroy

  has_many :leads,
    :class_name => "Lead",
    :foreign_key => "contact_id",
    :dependent => :destroy

  belongs_to :creator,
    :class_name => "User",
    :foreign_key => "created_by"

  has_one :user,
    :class_name => "User",
    :foreign_key => "contact_id"

  validates_presence_of :email,
    :message => "address is required"

  validates_presence_of :email_confirmation,
    :message => "requires confirmation",
    :if => :email_changed?, :on => :update,
    :unless => Proc.new { |q| q.user.nil? }

  validates_confirmation_of :email,
    :message => "should match confirmation",
    :if => :email_changed?, :on => :update,
    :unless => Proc.new { |q| q.user.nil? }

  validates_uniqueness_of :email, :scope => :created_by,
    :message => "is already used by another contact"

  validates_format_of :email,
    :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
    :message => "address is an invalid format"

  validates_format_of :website,
    :with => URI::regexp(%w(http https)),
    :allow_blank => true, :allow_nil => true,
    :message => "has invalid URL"

  before_validation do
    self.email.gsub!(" ", "") if self.email
  end

  # do not edit/create if user is delinquent
  validate :creator_account_current
  def creator_account_current
    if self.creator.present? && self.creator.delinquent?
      self.errors.add :base, "Your account is not current. Please update subscription <a href='/profile'>payment information</a>."
    end
  end

  # "<joe@usa.gov>"
  # "Joe <joe@usa.gov>"
  # "Joe America <joe@usa.gov>"
  def emailField

    sender_field = "<#{self.email}>"

    if self.first.present?

      sender_field = "#{self.first.capitalize} <#{self.email}>"

      if self.last.present?

        sender_field = "#{self.first.capitalize} #{self.last.capitalize} <#{self.email}>"

      end

    end

    return sender_field

  end

  # "joe@usa.gov"
  # "Joe"
  # "Joe America"
  def to_s

    sender_field = "#{self.email}"

    if self.first.present?

      sender_field = "#{self.first.capitalize}"

      if self.last.present?

        sender_field = "#{self.first.capitalize} #{self.last.capitalize}"

      end

    end

    return sender_field

  end

  # ""
  # "Joe"
  # "Joe America"
  def fullName

    fullName = ""

    if self.first.present?

      fullName = self.first.capitalize

      if self.last.present?

        fullName = "#{self.first.capitalize} #{self.last.capitalize}"

      end

    end

    return fullName

  end

end
