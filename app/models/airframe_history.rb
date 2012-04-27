# == Schema Information
# Schema version: 20120418040641
#
# Table name: airframe_histories
#
#  id          :integer         not null, primary key
#  airframe_id :integer
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  description :text
#  oldValue    :text
#  newValue    :text
#  changeField :string(255)
#
# Indexes
#
#  index_airframe_histories_on_user_id  (user_id)
#

class AirframeHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :airframe
end
