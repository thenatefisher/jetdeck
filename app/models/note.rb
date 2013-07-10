class Note < ActiveRecord::Base

  belongs_to :notable, :polymorphic => true
  validates_associated :notable
  validates_presence_of :notable

  belongs_to :author, :class_name => "User", :foreign_key => "created_by"
  validates_associated :author
  validates_presence_of :author

  belongs_to :creator,
    :class_name => "User",
    :foreign_key => "created_by"
    
  validates_presence_of :description

  # do not edit/create if user is delinquent
  validate :creator_account_current
  def creator_account_current
    if self.creator.delinquent?
      self.errors.add :base, "Your account is not current. Please update subscription <a href='/profile'>payment information</a>."
    end
  end
  
  def url
    "/#{notable_type.tolower}s/#{notable_id}"
  end

end
