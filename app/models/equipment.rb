class Equipment < ActiveRecord::Base
  belongs_to  :make,
              :foreign_key => 'manufacturer_id',
              :class_name => 'Manufacturer'
  has_many :airframes, :foreign_key => 'model_id'
  has_many :airframe_equipments
  has_many :airframes, :through => :airframe_equipments
end
