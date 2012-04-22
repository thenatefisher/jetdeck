class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.integer :user_id
      t.string :agent
      t.string :ip

      t.timestamps
    end
  end
end
