class RemoveBackgroundFromXspecs < ActiveRecord::Migration
  def up
    remove_column :xspecs, :background_id
  end

  def down
  end
end
