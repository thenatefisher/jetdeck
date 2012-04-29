class AddEngineIdToAirframeEquipment < ActiveRecord::Migration
  def change
    add_column :airframe_equipments, :engine_id, :integer
  end
end
