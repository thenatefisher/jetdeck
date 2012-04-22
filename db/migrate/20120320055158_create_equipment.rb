class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.references :manufacturer
      t.string :abbreviation
      t.string :modelNumber
      t.string :name
      t.text :description
      t.string :etype

      t.timestamps
    end
    add_index :equipment, :manufacturer_id
  end
end
