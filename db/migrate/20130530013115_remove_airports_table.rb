class RemoveAirportsTable < ActiveRecord::Migration
  def up
    drop_table :airports
  end

  def down
  end
end
