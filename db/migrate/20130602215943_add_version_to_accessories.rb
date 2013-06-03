class AddVersionToAccessories < ActiveRecord::Migration
  def change
    add_column :accessories, :version, :string
  end
end
