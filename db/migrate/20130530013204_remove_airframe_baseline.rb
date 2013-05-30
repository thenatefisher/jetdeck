class RemoveAirframeBaseline < ActiveRecord::Migration
  def up
    remove_column :airframes, :baseline_id
    remove_column :airframes, :baseline    
  end

  def down
  end
end
