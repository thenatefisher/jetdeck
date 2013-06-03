class DropXspecsTable < ActiveRecord::Migration
  def up
    drop_table :xspecs
  end

  def down
  end
end
