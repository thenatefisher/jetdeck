class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.integer :contact_id
      t.string :assoc
      t.integer :created_by
      t.string :description
      t.datetime :assigned

      t.timestamps
    end
  end
end
