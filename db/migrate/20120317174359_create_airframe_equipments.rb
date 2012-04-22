class CreateAirframeEquipments < ActiveRecord::Migration
  def change
    create_table :airframe_equipments do |t|
      t.integer :airframe_id
      t.integer :equipment_id
      t.string :type
      t.integer :user_id
      t.timestamps
    end
  end
end
