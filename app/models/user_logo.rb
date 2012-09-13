class UserLogo < ActiveRecord::Base

    belongs_to :user
    
    has_attached_file :image,
                      :styles => { :thumb => "x70" },    
                      :s3_credentials => "#{Rails.root}/config/aws_keys.yml",
                      :storage => :s3,
                      :s3_host_alias => 
                        Jetdeck::Application.config.aws_s3_bucket +
                        ".s3.amazonaws.com",
                      :s3_protocol => "https",
                      :url => 
                        Jetdeck::Application.config.aws_s3_bucket +
                        ".s3.amazonaws.com",
                      :bucket => Jetdeck::Application.config.aws_s3_bucket,
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

      "https://s3.amazonaws.com/" +
      Jetdeck::Application.config.aws_s3_bucket +
      "/logos/#{id}/thumb/#{image_file_name}"

    end

    def url_original

      "https://s3.amazonaws.com/" +
      Jetdeck::Application.config.aws_s3_bucket +
      "/logos/#{id}/original/#{image_file_name}"

    end

    def to_jq_upload
        {
          "name" => self.image_file_name,
          "size" => self.image_file_size,
          "url" => 
              "https://s3.amazonaws.com/" +
              Jetdeck::Application.config.aws_s3_bucket +
              "/logos/#{id}/original/#{image_file_name}",
          "thumbnail_url" => 
              "https://s3.amazonaws.com/" +
              Jetdeck::Application.config.aws_s3_bucket +
              "/logos/#{id}/thumb/#{image_file_name}",
          "delete_url" => "/user_logos",
          "delete_type" => "DELETE",
          "id" => self.id
        }
    end
   

end
