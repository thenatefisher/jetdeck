class CreateSpecViews < ActiveRecord::Migration
  def change
    create_table :spec_views do |t|
      t.integer :spec_id
      t.integer :timeOnPage
      t.string :agent
      t.string :ip

      t.timestamps
    end
  end
end
