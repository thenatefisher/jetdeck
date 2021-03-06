class Lead < ActiveRecord::Base

  belongs_to :airframe
  belongs_to :contact
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"

  validates_uniqueness_of :contact_id, :scope => :airframe_id

end
