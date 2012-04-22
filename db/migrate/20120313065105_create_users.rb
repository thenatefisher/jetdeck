class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :type
      t.integer :contact_id
      t.string :password

      t.timestamps
    end
  end
end
