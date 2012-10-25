class SetUserContactToNegOne < ActiveRecord::Migration
  def up
  
    User.all.each do |u|
      c = u.contact
      c.owner_id = -1
      c.save
    end
    
  end

  def down
  end
end
