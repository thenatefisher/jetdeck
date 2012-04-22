class AddDescToAirframeHistory < ActiveRecord::Migration
  def change
    add_column :airframe_histories, :description, :text
    add_column :airframe_histories, :field, :string
    add_column :airframe_histories, :oldValue, :text
    add_column :airframe_histories, :newValue, :text
  end
end
