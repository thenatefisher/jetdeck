class Location < ActiveRecord::Base
  has_many :airports
  has_many :addresses
end
