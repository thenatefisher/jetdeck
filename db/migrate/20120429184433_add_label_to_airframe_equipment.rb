class AddLabelToAirframeEquipment < ActiveRecord::Migration
  def change
    add_column :airframe_equipments, :label, :string

  end
end
