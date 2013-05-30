class RemoveEquipmentDetailsTable < ActiveRecord::Migration
  def up
    drop_table :equipment_details
  end

  def down
  end
end
