class AddModelNameToEngine < ActiveRecord::Migration
  def change
    add_column :engines, :modelName, :string

  end
end
