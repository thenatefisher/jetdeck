class AddHidePriceToXspecs < ActiveRecord::Migration
  def change


    add_column :xspecs, :hide_price, :boolean

  end
end
