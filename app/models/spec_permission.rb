# == Schema Information
# Schema version: 20120418040641
#
# Table name: spec_permissions
#
#  id         :integer         not null, primary key
#  spec_id    :integer
#  field      :string(255)
#  allowed    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class SpecPermission < ActiveRecord::Base
  belongs_to :xspec

end
