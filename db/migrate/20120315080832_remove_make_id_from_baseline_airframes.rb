class RemoveMakeIdFromBaselineAirframes < ActiveRecord::Migration
  def up
    remove_column :airframes, :make_id
    remove_column :baseline_airframes, :make_id
  end
end
