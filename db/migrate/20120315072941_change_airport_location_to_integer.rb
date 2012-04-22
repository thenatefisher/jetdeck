class ChangeAirportLocationToInteger < ActiveRecord::Migration
  def up
    remove_column :airports, :location_id
    add_column :airports, :location_id, :integer
  end
end
