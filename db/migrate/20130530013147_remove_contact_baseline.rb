class RemoveContactBaseline < ActiveRecord::Migration
  def up
    remove_column :contacts, :baseline_id
    remove_column :contacts, :baseline
  end

  def down
  end
end
