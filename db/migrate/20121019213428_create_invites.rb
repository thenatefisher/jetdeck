class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :from_user_id
      t.integer :to_contact_id
      t.boolean :activated
      t.text :message

      t.timestamps
    end
  end
end
