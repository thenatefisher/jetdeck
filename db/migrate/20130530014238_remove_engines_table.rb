class RemoveEnginesTable < ActiveRecord::Migration
  def up
    drop_table :engines
  end

  def down
  end
end
