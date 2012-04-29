class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :serial
      t.string :label
      t.integer :totalTime
      t.integer :totalCycles
      t.integer :year
      t.integer :smoh
      t.integer :tbo
      t.string :type
      t.integer :hsi
      t.integer :shsi
      t.integer :model_id
      t.boolean :baseline
      t.integer :baseline_id

      t.timestamps
    end
  end
end
