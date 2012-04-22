class CreateSpecPermissions < ActiveRecord::Migration
  def change
    create_table :spec_permissions do |t|
      t.integer :spec_id
      t.string :field
      t.boolean :allowed

      t.timestamps
    end
  end
end
