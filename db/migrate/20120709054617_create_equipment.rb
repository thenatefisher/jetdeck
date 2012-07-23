class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :type
      t.string :title
      t.string :name
      t.integer :airframe_id

      t.timestamps
    end
  end
end
