class Manufacturer < ActiveRecord::Base
  has_many :models, :class_name => "Equipment_Model"
end
