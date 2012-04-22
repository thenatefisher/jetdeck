class RemoveTotaltimeFromAirframe < ActiveRecord::Migration
  def up
    remove_column :airframes, :totaltime
    remove_column :airframes, :totalcycles
    add_column :airframes, :totalTime, :integer
    add_column :airframes, :totalCycles, :integer
  end


end
