class Accessory < ActiveRecord::Base

    belongs_to :airframe

    has_attached_file :image,
                      :styles => {  :thumb => "220x200#",
                                    :mini => "80x60",
                                    :listing => "210x157" },
                      :url  => "/assets/airframes/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/airframes/:id/:style/:basename.:extension"

    has_attached_file :document

    attr_protected :image_file_name, :image_content_type, :image_size

    attr_protected :document_file_name, :document_content_type, :document_size

    validates_attachment_size :image, :less_than => 5.megabytes

    validates_attachment_size :document, :less_than => 5.megabytes

    validates_attachment_content_type :image, :content_type =>
        ["image/png",
        "image/jpg",
        "image/jpeg",
        "image/tga",
        "image/bmp",
        "image/targa",
        "image/gif"]

    validates_attachment_content_type :document, :content_type =>
        ["application/pdf",
        "image/png",
        "image/jpg",
        "image/jpeg",
        "image/tga",
        "image/bmp",
        "image/gif",
        "image/targa",
        "application/msword", "application/x-msword",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/msexcel", "application/x-msexcel"]

      #one convenient method to pass jq_upload the necessary information
      def to_jq_upload
        {
          "name" => self.image_file_name,
          "size" => self.image_file_size,
          "url" => "/assets/airframes/#{id}/original/#{image_file_name}",
          "thumbnail_url" => "/assets/airframes/#{id}/mini/#{image_file_name}",
          "delete_url" => "/accessories/#{id}",
          "delete_type" => "DELETE"
        }
      end

end
