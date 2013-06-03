class AddEnabledToAccessories < ActiveRecord::Migration
  def change
    add_column :accessories, :enabled, :boolean
  end
end
