# == Schema Information
# Schema version: 20120429080558
#
# Table name: contacts
#
#  id          :integer         not null, primary key
#  first       :string(255)
#  last        :string(255)
#  source      :string(255)
#  email       :string(255)
#  company     :string(255)
#  title       :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  user_id     :integer
#  baseline_id :integer
#  baseline    :boolean
#

class Contact < ActiveRecord::Base

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

  has_one :owner,
      :class_name => 'User',
      :foreign_key => 'owner_id'

  has_one :user,
      :class_name => 'User',
      :foreign_key => 'contact_id'

  attr_accessible :phone, :first, :last, :source, :email, :company, :title, :description

  has_many :credits, :as => :creditable

  # todo uniqueness is also specific to an owner
  validates_presence_of :email

  validates_uniqueness_of :email

  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i


end
