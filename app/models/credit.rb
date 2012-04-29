# == Schema Information
# Schema version: 20120429080558
#
# Table name: credits
#
#  id              :integer         not null, primary key
#  user_id         :integer         indexed
#  creditable_type :string(255)
#  creditable_id   :integer
#  amount          :decimal(, )
#  direction       :boolean
#  description     :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :creditable, :polymorphic => true
end
