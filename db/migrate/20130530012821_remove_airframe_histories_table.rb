class RemoveAirframeHistoriesTable < ActiveRecord::Migration
  def up
    drop_table :airframe_histories
  end

  def down
  end
end
