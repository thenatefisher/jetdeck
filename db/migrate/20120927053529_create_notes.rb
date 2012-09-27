class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :description
      t.integer :created_by
      t.string :notable_type
      t.integer :notable_id

      t.timestamps
    end
  end
end
