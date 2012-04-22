class AddCreatorToAirframes < ActiveRecord::Migration
  def change
    add_column :airframes, :user_id, :integer

  end
end
