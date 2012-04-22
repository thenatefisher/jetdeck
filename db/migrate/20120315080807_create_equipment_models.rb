class CreateEquipmentModels < ActiveRecord::Migration
  def change
    create_table :equipment_models do |t|
      t.integer :manufacturer_id
      t.string :abbreviation
      t.string :modelNumber
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
