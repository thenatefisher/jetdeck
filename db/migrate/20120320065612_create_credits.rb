class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :user
      t.string :creditable_type
      t.integer :creditable_id
      t.decimal :amount
      t.boolean :direction
      t.text :description

      t.timestamps
    end
    add_index :credits, :user_id
  end
end
