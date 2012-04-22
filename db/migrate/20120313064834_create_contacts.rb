class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first
      t.string :last
      t.string :source
      t.string :email
      t.string :company
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
