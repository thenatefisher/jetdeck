class CreateEquipmentDetails < ActiveRecord::Migration
  def change
    create_table :equipment_details do |t|
      t.integer :equipment_id
      t.string :value
      t.string :parameter

      t.timestamps
    end
  end
end
