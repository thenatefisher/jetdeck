class DeleteBaselineAirframes < ActiveRecord::Migration
  def up
    drop_table :baseline_airframes
  end

  def down
  end
end
