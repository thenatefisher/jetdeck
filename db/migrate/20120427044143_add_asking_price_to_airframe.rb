class AddAskingPriceToAirframe < ActiveRecord::Migration
  def change
    add_column :airframes, :asking_price, :integer

  end
end
