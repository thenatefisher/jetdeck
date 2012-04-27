# == Schema Information
# Schema version: 20120418040641
#
# Table name: locations
#
#  id                 :integer         not null, primary key
#  city               :string(255)
#  country            :string(255)
#  state              :string(255)
#  registrationPrefix :string(255)
#  salesTax           :float
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  stateAbbreviation  :string(255)
#

class Location < ActiveRecord::Base
  has_many :airports
  has_many :addresses
end
