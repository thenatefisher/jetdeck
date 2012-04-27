# == Schema Information
# Schema version: 20120418040641
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
