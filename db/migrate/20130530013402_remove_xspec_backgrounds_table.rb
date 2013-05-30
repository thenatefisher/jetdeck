class RemoveXspecBackgroundsTable < ActiveRecord::Migration
  def up
        drop_table :xspec_backgrounds
  end

  def down
  end
end
