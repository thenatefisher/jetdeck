class RemoveFormatFromXspecs < ActiveRecord::Migration

  def up
    remove_column :xspecs, :format
  end

  def down
  end
end
