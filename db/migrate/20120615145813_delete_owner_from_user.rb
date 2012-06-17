class DeleteOwnerFromUser < ActiveRecord::Migration
  def up
   remove_column :users, :owner_id
  end

  def down
  end
end
