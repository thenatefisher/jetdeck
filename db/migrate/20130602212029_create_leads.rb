class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.integer :recipient_id
      t.integer :sender_id
      t.integer :airframe_id
      t.integer :status_id
      t.datetime :status_date
      t.integer :spec_id
      t.boolean :photos_enabled
      t.boolean :spec_enabled
      t.string  :override_file_name
      t.string  :photos_url_code
      t.string  :spec_url_code
      t.text    :body
      t.text    :subject

      t.timestamps
    end
  end
end
