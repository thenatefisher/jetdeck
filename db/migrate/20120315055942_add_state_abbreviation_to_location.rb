class AddStateAbbreviationToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :state_abbreviation, :string

  end
end
