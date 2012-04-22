class AddStateAbbreviationToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :stateAbbreviation, :string

  end
end
