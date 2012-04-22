class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :location_id
      t.string :postal
      t.integer :contact_id
      t.string :label
      t.text :description
      t.string :line1
      t.string :line2
      t.string :line3

      t.timestamps
    end
  end
end
