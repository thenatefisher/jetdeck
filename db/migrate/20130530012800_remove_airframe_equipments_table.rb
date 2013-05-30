class RemoveAirframeEquipmentsTable < ActiveRecord::Migration
  def up
    drop_table :airframe_equipments
  end

  def down
  end
end
