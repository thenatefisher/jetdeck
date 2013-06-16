class AddCreatorToAccessories < ActiveRecord::Migration
  def change
    add_column :accessories, :creator_id, :integer
  end
end
