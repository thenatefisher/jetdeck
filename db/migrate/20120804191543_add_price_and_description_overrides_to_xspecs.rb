class AddPriceAndDescriptionOverridesToXspecs < ActiveRecord::Migration
  def change
    add_column :xspecs, :override_price, :string

    add_column :xspecs, :override_description, :text

  end
end
