class AddBackgroundToXspec < ActiveRecord::Migration
  def change
    add_column :xspec_backgrounds, :background_file_name, :string

    add_column :xspec_backgrounds, :background_content_type, :string

    add_column :xspec_backgrounds, :background_file_size, :integer

    add_column :xspec_backgrounds, :background_updated_at, :datetime
  end
end
