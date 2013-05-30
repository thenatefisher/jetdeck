class AddDocumentToXspecs < ActiveRecord::Migration
  def change
    add_column :xspecs, :document_id, :integer
  end
end
