class AddStickyToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :sticky_id, :integer
  end
end
