class AddBaselineAirframeToAirframes < ActiveRecord::Migration
  def change
    add_column :airframes, :baseline_id, :integer
  end
end
