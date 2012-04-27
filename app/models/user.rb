# == Schema Information
# Schema version: 20120418040641
#
# Table name: users
#
#  id            :integer         not null, primary key
#  type          :integer
#  contact_id    :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  password_hash :string(255)
#  password_salt :string(255)
#  active        :boolean
#
# Indexes
#
#  indexusers_on_contact_id  (contact_id)
#

require 'bcrypt'

class User < ActiveRecord::Base

  attr_accessible :password,
                  :password_confirmation,
                  :contact,
                  :contact_id,
                  :airframes,
                  :active

  attr_accessor  :password

  before_save :encrypt_password
  before_create :set_defaults

  has_many :logins
  has_many :airframes, :dependent => :destroy
  has_many :credits
  belongs_to :contact

  validates_uniqueness_of :contact_id
  validates_presence_of :contact_id, :on => :create
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password

  def set_defaults

    # default to active status
    if active == false
      self.active = false
    else
      self.active = true
    end

    # default 10 credits for new users
    self.credits << Credit.create(:amount=>10, :direction=>true)

  end

  def encrypt_password
    if password.present?
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

  def sell(record)
    # copy record to baseline list
    if (record.respond_to?(:baseline) &&
        record.baseline == false &&
        record.baseline_id == nil &&
        record.creator == self)

      # calculate the value of this record
      saleValue = 1

      # update current baseline for this record (if available)

      # OR copy the record and set baseline flag
      a = record.class.create(record.attributes)
      a.baseline = true
      a.save

      # configure original record so it can't be sold again
      record.baseline_id = a.id

      # enter credit transaction record
      # credit user with half of the value now
      # second half comes after quorem likes it
      self.credits << Credit.create(
        :amount=>(saleValue*0.5),
        :direction=>true)

    end
  end

  def buy(record)
    # got the coin?
    self.balance >= 3
    # copy record from baseline list
    if record.respond_to?(:baseline) && record.baseline == true
      # copy the record and unset baseline flag
      a = record.class.create(record.attributes)
      a.baseline = false
      a.baseline_id = record.id
      a.creator = self
      a.save
      # enter debit transaction record
      self.credits << Credit.create(:amount=>3, :direction=>false)
    end
  end

  def balance
    c = self.credits.where('direction = 1').sum(:amount).to_i
    d = self.credits.where('direction = 0').sum(:amount).to_i
    c - d
  end

end
