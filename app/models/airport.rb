class Airport < ActiveRecord::Base
  belongs_to :location
  validates_presence_of :icao
  validates_uniqueness_of :icao
  has_many :airframes
end
