class Ownership < ActiveRecord::Base

  attr_accessible :contact_id, :assoc, :description

  belongs_to :contact
  
  validates_presence_of :contact_id
  
end
