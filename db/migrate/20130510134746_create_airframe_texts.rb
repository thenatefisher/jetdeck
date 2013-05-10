class CreateAirframeTexts < ActiveRecord::Migration
  def change
    create_table :airframe_texts do |t|
      t.integer :airframe_id
      t.text :body
      t.string :label

      t.timestamps
    end
  end
end
