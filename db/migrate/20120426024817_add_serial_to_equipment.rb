class AddSerialToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :serial, :string

  end
end
