class Lead < ActiveRecord::Base

  belongs_to :airframe
  belongs_to :contact
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"

  before_create :init

  validates_associated :airframe
  validates_presence_of :airframe
  validates_associated :contact
  validates_presence_of :contact
  validates_associated :creator
  validates_presence_of :creator

end
