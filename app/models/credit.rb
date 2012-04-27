# == Schema Information
# Schema version: 20120418040641
#
# Table name: credits
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  creditable_type :string(255)
#  creditable_id   :integer
#  amount          :decimal(, )
#  direction       :boolean
#  description     :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#
# Indexes
#
#  index_credits_on_user_id  (user_id)
#

class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :creditable, :polymorphic => true
end
