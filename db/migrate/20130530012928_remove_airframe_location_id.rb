class RemoveAirframeLocationId < ActiveRecord::Migration
  def up
    remove_column :airframes, :location_id
  end

  def down
  end
end
