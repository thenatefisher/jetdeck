class RemoveFieldFromAircraftHistory < ActiveRecord::Migration
  def up
    remove_column :airframe_histories, :field
    add_column :airframe_histories, :changeField, :string
  end

  def down
  end
end
