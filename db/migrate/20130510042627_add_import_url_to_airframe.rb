class AddImportUrlToAirframe < ActiveRecord::Migration
  def change
    add_column :airframes, :import_url, :text
  end
end
