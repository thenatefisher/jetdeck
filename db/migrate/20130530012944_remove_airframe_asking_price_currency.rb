class RemoveAirframeAskingPriceCurrency < ActiveRecord::Migration
  def up
    remove_column :airframes, :asking_price_currency
  end

  def down
  end
end
