class AddBaselineToAirframes < ActiveRecord::Migration
  def change
    add_column :airframes, :baseline, :boolean

  end
end
