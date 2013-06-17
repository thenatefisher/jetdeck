class Accessory < ActiveRecord::Base

    belongs_to :airframe
    has_one :lead, :foreign_key => :spec_id, :class_name => "Lead"
    belongs_to :creator, :foreign_key => :creator_id, :class_name => "User"

    has_attached_file :image,
                      :styles => {  :thumb => "140x130#", # displayed on show page
                                    :mini => "80x60#", # on show page in picture list
                                    :slides => { 
                                      :processors => [:cropper], 
                                      :geometry => "NONE" },
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
                      :s3_permissions => :authenticated_read,
                      :path => ":attachment/:id/:style/:basename.:extension"

    has_attached_file :document,
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
                      :s3_permissions => :authenticated_read,
                      :path => ":attachment/:id/:basename.:extension"                      

    attr_protected :version, :image_file_name, :image_content_type, :image_size, 
                    :document_file_name, :document_content_type, :document_size

    validate :validate_image_or_document
   
    validates_presence_of :airframe_id

    validates_attachment_size :image, :less_than => 5.megabytes

    validates_attachment_size :document, :less_than => 10.megabytes

    validates_attachment_content_type :document, :content_type =>
        ["application/msword",
         "application/pdf"]

    validates_attachment_content_type :image, :content_type =>
        ["image/png",
        "image/jpg",
        "image/jpeg",
        "image/tga",
        "image/bmp",
        "image/targa",
        "image/gif"]

    before_destroy :next_thumbnail, :if => 'image_file_name.present?'

    before_create :init, :update_version

    # validate before save cannot have both image and doc
    def validate_image_or_document
      if image_file_name && document_file_name
        errors.add(:image, " cannot be in same accessory as a document")
        errors.add(:document, " cannot be in same accessory as an image")
      end
    end

    # validate before save version must be present and must 
    # have unique version for airframe+filename pair
    def update_version

      if document_file_name.present?
        accys = Accessory.find(:all, :select => 'version', :conditions => ["airframe_id = ? AND document_file_name = ?",
          self.airframe_id, self.document_file_name])
        	versions = accys.map{|a| a.version} if accys.present?
        	self.version = (versions.max+1) if versions.present?
        	self.version ||= 0
      end

    end

    def init
      self.enabled ||= true
    end

    # select another thumbnail if it is deleted
    def next_thumbnail

      if self.image.present? && self.thumbnail
          new_thumb = self.airframe.accessories.where("image_file_name IS NOT null AND thumbnail = 'f'").first
          if new_thumb
              new_thumb.thumbnail = true
              new_thumb.save()
          end
      else
        false
      end

    end

    def url(style="original", expires_in = 30.minutes)
      if self.image.present?
        self.image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
      else      
        self.document.s3_object().url_for(:read, :secure => true, :expires => expires_in).to_s
      end
    end

    #one convenient method to pass jq_upload the necessary information
    def to_jq_upload

      if self.image.present?
          {
            "name" => self.image_file_name,
            
            "size" => self.image_file_size,
            
            "url" => self.image.s3_object("original").url_for(:read, :secure => true, :expires => 1.day).to_s,
              
            "thumbnail_url" => self.image.s3_object("mini").url_for(:read, :secure => true, :expires => 1.day).to_s,
              
            "delete_url" => "/accessories/#{id}",
            
            "delete_type" => "DELETE",
            
            "is_thumbnail" => self.thumbnail,
            
            "id" => self.id
          }
      else
          {
            "name" => self.document_file_name,
            
            "size" => self.document_file_size,
            
            "url" => self.document.s3_object("original").url_for(:read, :secure => true, :expires => 1.day).to_s,
              
            "delete_url" => "/accessories/#{id}",
            
            "delete_type" => "DELETE",
            
            "is_thumbnail" => false,
            
            "id" => self.id
          } 
      end    

    end

end
