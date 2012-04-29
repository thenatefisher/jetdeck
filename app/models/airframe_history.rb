# == Schema Information
# Schema version: 20120429080558
#
# Table name: airframe_histories
#
#  id          :integer         not null, primary key
#  airframe_id :integer
#  user_id     :integer         indexed
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  description :text
#  oldValue    :text
#  newValue    :text
#  changeField :string(255)
#

class AirframeHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :airframe
end
