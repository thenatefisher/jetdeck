class CreateXspec < ActiveRecord::Migration
  def up
   
    create_table :xspecs do |t|
      t.integer  "airframe_id"
      t.integer  "recipient_id"
      t.integer  "sender_id"
      t.datetime "sent"
      t.string   "format"
      t.text     "message"
      t.timestamps
    end
  end

  def down
  end
end
