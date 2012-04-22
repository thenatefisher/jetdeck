class CreateAirframes < ActiveRecord::Migration
  def change
    create_table :airframes do |t|
      t.string :serial
      t.string :registration
      t.references :make
      t.references :model
      t.integer :year
      t.integer :totaltime
      t.integer :totalcycles

      t.timestamps
    end
    add_index :airframes, :make_id
    add_index :airframes, :model_id
  end
end
