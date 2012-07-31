class ChangeTypeToCategoryInEquipment < ActiveRecord::Migration
  def up
    add_column :equipment, :etype, :string
    remove_column :equipment, :type
  end
end
