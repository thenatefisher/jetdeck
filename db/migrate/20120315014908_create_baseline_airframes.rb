class CreateBaselineAirframes < ActiveRecord::Migration
  def change
    create_table :baseline_airframes do |t|
      t.string :serial
      t.string :registration
      t.integer :make_id
      t.integer :model_id
      t.integer :year
      t.integer :totaltime
      t.integer :totalcycles

      t.timestamps
    end
  end
end
