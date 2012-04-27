class AddAskingPriceToAirframe < ActiveRecord::Migration
  def change
    add_column :airframes, :askingPrice, :integer

  end
end
