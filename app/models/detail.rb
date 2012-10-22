class Detail < ActiveRecord::Base

  belongs_to :detailable, :polymorphic => true
  
end
