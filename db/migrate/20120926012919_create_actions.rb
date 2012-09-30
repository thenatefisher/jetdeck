class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :title
      t.text :description
      t.datetime :due_at
      t.integer :actionable_id
      t.integer :created_by
      t.string :actionable_type
      t.boolean :is_completed
      t.datetime :completed_at

      t.timestamps
    end
  end
end
