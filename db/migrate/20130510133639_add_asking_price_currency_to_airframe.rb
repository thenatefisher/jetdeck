class AddAskingPriceCurrencyToAirframe < ActiveRecord::Migration
  def change
    add_column :airframes, :asking_price_currency, :string
  end
end
