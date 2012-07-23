class AddAirframeToEngine < ActiveRecord::Migration
  def change
    add_column :engines, :airframe_id, :integer

  end
end
