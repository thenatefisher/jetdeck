class CreateAirframeTexts < ActiveRecord::Migration
  def change
    create_table :airframe_texts do |t|
      t.integer :airframe_id
      t.text :body
      t.string :label

      t.timestamps
    end

    # set all current users as activated
    User.all.each do |u|
      u.generate_token(:bookmarklet_token)
      u.save
    end

  end
end
