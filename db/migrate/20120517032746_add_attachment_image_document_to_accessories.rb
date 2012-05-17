class AddAttachmentImageDocumentToAccessories < ActiveRecord::Migration
  def self.up
    add_column :accessories, :image_file_name, :string
    add_column :accessories, :image_content_type, :string
    add_column :accessories, :image_file_size, :integer
    add_column :accessories, :image_updated_at, :datetime
    add_column :accessories, :document_file_name, :string
    add_column :accessories, :document_content_type, :string
    add_column :accessories, :document_file_size, :integer
    add_column :accessories, :document_updated_at, :datetime
  end

  def self.down
    remove_column :accessories, :image_file_name
    remove_column :accessories, :image_content_type
    remove_column :accessories, :image_file_size
    remove_column :accessories, :image_updated_at
    remove_column :accessories, :document_file_name
    remove_column :accessories, :document_content_type
    remove_column :accessories, :document_file_size
    remove_column :accessories, :document_updated_at
  end
end
