class RemoveCreditsTable < ActiveRecord::Migration
  def up
    drop_table :credits
  end

  def down
  end
end
