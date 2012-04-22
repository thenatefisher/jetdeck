class CreateAirframeHistories < ActiveRecord::Migration
  def change
    create_table :airframe_histories do |t|
      t.references :airframe
      t.references :user

      t.timestamps
    end
    add_index :airframe_histories, :user_id
  end
end
