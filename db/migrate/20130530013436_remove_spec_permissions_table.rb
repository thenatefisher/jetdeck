class RemoveSpecPermissionsTable < ActiveRecord::Migration
  def up
    drop_table :spec_permissions
  end

  def down
  end
end
