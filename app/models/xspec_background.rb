class XspecBackground < ActiveRecord::Base

    has_many :xspecs
    
    has_attached_file :image,
                      :styles => { :thumb => "30x30#" },    
                      :s3_credentials => "#{Rails.root}/config/aws_keys.yml",
                      :storage => :s3,
                      :s3_host_alias => "jetdeck.s3.amazonaws.com",
                      :url => "jetdeck.s3.amazonaws.com",
                      :bucket => "jetdeck",
                      :s3_permissions => :public_read,
                      :path => "backgrounds/:id/:style/:basename.:extension"

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
        
     def thumbnail
     
      "http://s3.amazonaws.com/jetdeck/backgrounds/#{id}/thumb/#{image_file_name}"
      
     end
     
     def url
     
      "http://s3.amazonaws.com/jetdeck/backgrounds/#{id}/original/#{image_file_name}"
      
     end

end
