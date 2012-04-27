# == Schema Information
# Schema version: 20120418040641
#
# Table name: logins
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  agent      :string(255)
#  ip         :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Login < ActiveRecord::Base
  belongs_to :user

end
