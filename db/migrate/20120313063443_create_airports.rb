class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :icao
      t.string :latitude
      t.string :longitude
      t.string :name
      t.integer :location_id

      t.timestamps
    end
  end
end
