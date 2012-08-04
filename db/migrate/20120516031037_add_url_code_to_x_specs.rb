class AddUrlCodeToXSpecs < ActiveRecord::Migration
  def change
    add_column :xspecs, :url_code, :string

  end
end
