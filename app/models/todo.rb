class Todo < ActiveRecord::Base

  belongs_to :actionable, :polymorphic => true
  before_save :completed_time

  belongs_to :creator,
    :class_name => "User",
    :foreign_key => "created_by"
    
  validates_associated :actionable
  validates_presence_of :actionable
  validates_presence_of :title

  # do not edit/create if user is delinquent
  validate :creator_account_current
  def creator_account_current
    if self.creator.delinquent?
      self.errors.add :base, "Your account is not current. Please update subscription <a href='/profile'>payment information</a>."
    end
  end
  
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
