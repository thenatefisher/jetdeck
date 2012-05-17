class CreateAccessories < ActiveRecord::Migration
  def change
    create_table :accessories do |t|
      t.string :name
      t.string :type
      t.integer :airframe_id

      t.timestamps
    end
  end
end
