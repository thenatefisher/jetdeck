class ChangeAirportToLocationInAirframe < ActiveRecord::Migration
  def up
  	add_column :airframes, :location_id, :integer
  	remove_column :airframes, :airport_id
  end

  def down
  end
end
