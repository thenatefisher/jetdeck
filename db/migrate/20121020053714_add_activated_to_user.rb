class AddActivatedToUser < ActiveRecord::Migration
  def change
    
    add_column :users, :activated, :boolean
    
    # set all current users as activated
    User.all.each do |u|
      u.activated = true
      u.save
    end

  end
end
