class RemoveEquipmentTable < ActiveRecord::Migration
  def up
    drop_table :equipment
  end

  def down
  end
end
