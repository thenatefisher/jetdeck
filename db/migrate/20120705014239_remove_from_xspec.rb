class RemoveFromXspec < ActiveRecord::Migration
  def up
    remove_column :xspec_backgrounds, :background_file_name

    remove_column :xspec_backgrounds, :background_content_type

    remove_column :xspec_backgrounds, :background_file_size

    remove_column :xspec_backgrounds, :background_updated_at
  end

  def down
  end
end
