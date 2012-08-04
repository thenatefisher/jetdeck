class AddAirportToAirframes < ActiveRecord::Migration
  def change
    add_column :airframes, :airport_id, :integer

  end
end
