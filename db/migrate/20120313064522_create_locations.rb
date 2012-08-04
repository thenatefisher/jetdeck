class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :city
      t.string :country
      t.string :state
      t.string :registration_prefix
      t.float :salesTax

      t.timestamps
    end
  end
end
