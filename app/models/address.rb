# == Schema Information
# Schema version: 20120429080558
#
# Table name: addresses
#
#  id          :integer         not null, primary key
#  location_id :integer
#  postal      :string(255)
#  contact_id  :integer
#  label       :string(255)
#  description :text
#  line1       :string(255)
#  line2       :string(255)
#  line3       :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Address < ActiveRecord::Base
  belongs_to :location
  belongs_to :contact
end
