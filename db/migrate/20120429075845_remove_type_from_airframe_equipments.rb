class RemoveTypeFromAirframeEquipments < ActiveRecord::Migration
  def up
     remove_column :airframe_equipments, :type
  end

  def down
  end
end
