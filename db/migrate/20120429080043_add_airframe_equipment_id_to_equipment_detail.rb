class AddAirframeEquipmentIdToEquipmentDetail < ActiveRecord::Migration
  def change
   add_column :equipment_details, :airframeEquipment_id, :integer
  end
end
