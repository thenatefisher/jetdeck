# == Schema Information
# Schema version: 20120429080558
#
# Table name: spec_views
#
#  id         :integer         not null, primary key
#  spec_id    :integer
#  timeOnPage :integer
#  agent      :string(255)
#  ip         :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class SpecView < ActiveRecord::Base
  belongs_to :xspec

end
