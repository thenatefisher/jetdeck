class AddTypeToEquipmentModels < ActiveRecord::Migration
  def change
    add_column :equipment_models, :etype, :string

  end
end
