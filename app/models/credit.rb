class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :creditable, :polymorphic => true
end
