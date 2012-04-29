# == Schema Information
# Schema version: 20120429080558
#
# Table name: airframe_contacts
#
#  id          :integer         not null, primary key
#  airframe_id :integer
#  contact_id  :integer
#  relation    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class AirframeContact < ActiveRecord::Base
end
