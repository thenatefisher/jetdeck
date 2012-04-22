class DropEquipmentModels < ActiveRecord::Migration
  def up
    drop_table :equipment_models
  end

  def down
  end
end
