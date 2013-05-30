class RemoveManufactgurersTable < ActiveRecord::Migration
  def up
    drop_table :manufacturers
  end

  def down
  end
end
