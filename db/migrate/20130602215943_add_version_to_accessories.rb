class AddVersionToAccessories < ActiveRecord::Migration
  def change
    add_column :accessories, :version, :integer
    add_column :accessories, :file_hash, :string
  end
end
