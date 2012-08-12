class UserLogo < ActiveRecord::Base

    belongs_to :user
    
    has_attached_file :image,
                      :styles => { :thumb => "x70" },    
                      :s3_credentials => "#{Rails.root}/config/aws_keys.yml",
                      :storage => :s3,
                      :s3_host_alias => "jetdeck.s3.amazonaws.com",
                      :url => "jetdeck.s3.amazonaws.com",
                      :bucket => "jetdeck",
                      :s3_permissions => :public_read,
                      :path => "logos/:id/:style/:basename.:extension"

    attr_protected :image_file_name, :image_content_type, :image_size

    validates_attachment_size :image, :less_than => 2.megabytes

    validates_attachment_content_type :image, :content_type =>
        ["image/png",
        "image/jpg",
        "image/jpeg",
        "image/tga",
        "image/bmp",
        "image/targa",
        "image/gif"]
      
    def url

      "http://s3.amazonaws.com/jetdeck/logos/#{id}/thumb/#{image_file_name}"

    end

    def url_original

      "http://s3.amazonaws.com/jetdeck/logos/#{id}/original/#{image_file_name}"

    end

    def to_jq_upload
        {
          "name" => self.image_file_name,
          "size" => self.image_file_size,
          "url" => "http://s3.amazonaws.com/jetdeck/logos/#{id}/original/#{image_file_name}",
          "thumbnail_url" => "http://s3.amazonaws.com/jetdeck/logos/#{id}/thumb/#{image_file_name}",
          "delete_url" => "/user_logos",
          "delete_type" => "DELETE",
          "id" => self.id
        }
    end
   

end
