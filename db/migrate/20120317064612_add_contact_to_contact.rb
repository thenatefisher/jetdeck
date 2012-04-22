class AddContactToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :baseline_id, :integer
    add_column :contacts, :baseline, :boolean
  end
end
