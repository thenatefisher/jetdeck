class AddDescriptionToAirframe < ActiveRecord::Migration
  def change

    add_column :airframes, :description, :text

  end
end
