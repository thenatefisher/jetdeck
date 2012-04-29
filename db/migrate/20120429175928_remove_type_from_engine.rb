class RemoveTypeFromEngine < ActiveRecord::Migration
  def up
    remove_column :engines, :type
    remove_column :engines, :label
  end

  def down
  end
end
