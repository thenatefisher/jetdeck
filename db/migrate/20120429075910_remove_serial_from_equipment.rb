class RemoveSerialFromEquipment < ActiveRecord::Migration
  def up
    remove_column :equipment, :serial
  end

  def down
  end
end
