class RemoveAlertsTable < ActiveRecord::Migration
  def up
    drop_table :alerts
  end

  def down
  end
end
