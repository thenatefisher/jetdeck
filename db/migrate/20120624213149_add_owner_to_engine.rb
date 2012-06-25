class AddOwnerToEngine < ActiveRecord::Migration
  def change
    add_column :engines, :owner_id, :integer

  end
end
