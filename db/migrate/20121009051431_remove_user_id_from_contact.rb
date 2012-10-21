class RemoveUserIdFromContact < ActiveRecord::Migration
  def up
    remove_column :contacts, :user_id
  end

  def down
  end
end
