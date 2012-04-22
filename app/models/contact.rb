class Contact < ActiveRecord::Base

  has_one :user
  has_many :specsSent,
      :class_name => "Airframe",
      :foreign_key => "sender"
  has_many :specsReceived,
      :class_name => "Airframe",
      :foreign_key => "recipient"
  has_one :base,
      :class_name => 'Contact',
      :foreign_key => 'baseline_id',
      :readonly => true

  attr_accessible :first, :last, :source, :email, :company, :title, :description

  has_many :credits, :as => :creditable

  validates_presence_of :email
  validates_uniqueness_of :email

end
