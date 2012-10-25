class SetUserInvitesToTen < ActiveRecord::Migration
  def up
  
    User.all.each do |u|
      u.invites = 10
      u.save
    end
      
  end

  def down
  end
end
