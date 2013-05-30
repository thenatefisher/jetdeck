class RemoveDetailsTable < ActiveRecord::Migration
  def up
    drop_table :details
  end

  def down
  end
end
