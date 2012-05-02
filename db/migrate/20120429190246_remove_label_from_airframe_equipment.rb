class RemoveLabelFromAirframeEquipment < ActiveRecord::Migration
  def up
    remove_column :airframe_equipments, :label
  end

  def down
  end
end
