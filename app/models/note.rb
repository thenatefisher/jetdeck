class Note < ActiveRecord::Base
  belongs_to :notable, :polymorphic => true
  
  def url
    "/#{notable_type.tolower}s/#{notable_id}"
  end
  
end
