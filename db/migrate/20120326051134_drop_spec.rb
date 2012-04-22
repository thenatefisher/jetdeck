class DropSpec < ActiveRecord::Migration
  def up
    drop_table :specs
    create_table :xspecs do |t|
      t.integer  "airframe_id"
      t.integer  "recipient"
      t.integer  "sender"
      t.datetime "sent"
      t.string   "format"
      t.text     "message"
      t.boolean  "published"
      t.timestamps
    end
  end

  def down
  end
end
