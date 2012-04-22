class CreateSpecs < ActiveRecord::Migration
  def change
    create_table :specs do |t|
      t.integer :airframe_id
      t.integer :recipient
      t.integer :sender
      t.datetime :sent
      t.string :format
      t.text :message
      t.boolean :published

      t.timestamps
    end
  end
end
