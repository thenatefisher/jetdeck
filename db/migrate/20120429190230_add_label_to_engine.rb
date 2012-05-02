class AddLabelToEngine < ActiveRecord::Migration
  def change
    add_column :engines, :label, :string

  end
end
