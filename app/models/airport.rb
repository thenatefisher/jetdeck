# == Schema Information
# Schema version: 20120429080558
#
# Table name: airports
#
#  id          :integer         not null, primary key
#  icao        :string(255)
#  latitude    :string(255)
#  longitude   :string(255)
#  name        :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  location_id :integer
#

class Airport < ActiveRecord::Base
  belongs_to :location
  validates_presence_of :icao
  validates_uniqueness_of :icao

end
