class Action < ActiveRecord::Base

  belongs_to :actionable, :polymorphic => true
  before_save :completed_time
  
  validates_associated :actionable
  validates_presence_of :actionable

  def url
    "/#{actionable_type.downcase}s/#{actionable_id}"
  end
  
  def completed_time
  
    self.is_completed ||= false
    
    if self.is_completed
      self.completed_at = Time.now()
    else
      self.completed_at = nil
    end  
    
  end

end
