class Note < ActiveRecord::Base
  belongs_to :notable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "created_by"
  
  def url
    "/#{notable_type.tolower}s/#{notable_id}"
  end
  
end
