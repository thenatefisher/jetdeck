class Accessory < ActiveRecord::Base

    belongs_to :airframe

    has_attached_file :image,
                      :styles => {  :thumb => "140x130#", # displayed on show page
                                    :mini => "80x60#", # on show page in picture list
                                    :slides => { :processors => [:cropper], :geometry => "NONE" },
                                    :listing => "75x75#" }, # on index page
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
                      :path => ":attachment/:id/:style/:basename.:extension"

    attr_protected :image_file_name, :image_content_type, :image_size

    validates_attachment_size :image, :less_than => 8.megabytes

    validates_attachment_content_type :image, :content_type =>
        ["image/png",
        "image/jpg",
        "image/jpeg",
        "image/tga",
        "image/bmp",
        "image/targa",
        "image/gif"]

    before_destroy :next_thumbnail

    def next_thumbnail

        if self.thumbnail
            new_thumb = self.airframe.accessories.where("image_file_name IS NOT null AND thumbnail = 'f'").first
            if new_thumb
                new_thumb.thumbnail = true
                new_thumb.save()
            end
        end

    end        

    #one convenient method to pass jq_upload the necessary information
    def to_jq_upload
        {
          "name" => self.image_file_name,
          
          "size" => self.image_file_size,
          
          "url" => 
            "https://s3.amazonaws.com/" + 
            Jetdeck::Application.config.aws_s3_bucket + 
            "/images/#{id}/original/#{image_file_name}",
            
          "thumbnail_url" => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket +
            "/images/#{id}/mini/#{image_file_name}",
            
          "delete_url" => "/accessories/#{id}",
          
          "delete_type" => "DELETE",
          
          "is_thumbnail" => self.thumbnail,
          
          "id" => self.id
        }
    end

end
