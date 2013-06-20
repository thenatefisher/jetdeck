class Note < ActiveRecord::Base

  belongs_to :notable, :polymorphic => true
  validates_associated :notable
  validates_presence_of :notable

  belongs_to :author, :class_name => "User", :foreign_key => "created_by"
  validates_associated :author
  validates_presence_of :author

  validates_presence_of :body

  def url
    "/#{notable_type.tolower}s/#{notable_id}"
  end
  
end
