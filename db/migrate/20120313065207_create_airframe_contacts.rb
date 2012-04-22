class CreateAirframeContacts < ActiveRecord::Migration
  def change
    create_table :airframe_contacts do |t|
      t.integer :airframe_id
      t.integer :contact_id
      t.string :relation

      t.timestamps
    end
  end
end
