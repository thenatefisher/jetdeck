class Action < ActiveRecord::Base
  belongs_to :actionable, :polymorphic => true
  
  def url
    "/#{actionable_type.tolower}s/#{actionable_id}"
  end

end
