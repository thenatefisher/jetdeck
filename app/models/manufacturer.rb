# == Schema Information
# Schema version: 20120429080558
#
# Table name: manufacturers
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Manufacturer < ActiveRecord::Base
  has_many :models, :class_name => "Equipment_Model"
end
