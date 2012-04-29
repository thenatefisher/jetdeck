class RemoveEquipmentIdFromEquipmentDetail < ActiveRecord::Migration
  def up
    remove_column :equipment_details, :equipment_id
  end

  def down
  end
end
