class AirframeSpec < ActiveRecord::Base

    attr_protected :spec_file_name, :spec_content_type, :spec_file_size, :creator, :spec

    belongs_to :airframe
    validates_associated :airframe
    validates_presence_of :airframe

    belongs_to :creator, :foreign_key => :created_by, :class_name => "User"
    validates_associated :creator
    validates_presence_of :creator

    has_many :airframe_messages

    has_attached_file :spec,
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
    validates_attachment_size :spec, :less_than => 10.megabytes
    validates_presence_of :spec
    validates_attachment_content_type :spec, :content_type =>
        ["application/msword",
         "application/pdf"]
    validate :validate_space_available

    before_create :init

    def init
      self.enabled ||= true
    end

    # do not create a spec if use is over quota
    def validate_space_available
      if (self.creator.storage_usage + self.spec_file_size) >= self.creator.storage_quota
        self.errors.add :spec, "exceeds account storage allowance"
        return false
      end
    end

    # one convenient method to get an AWS s3 url
    def url(expires_in=30.minutes)
        self.spec.s3_object().url_for(:read, :secure => true, :expires => expires_in).to_s
    end

    # one convenient method to pass jq_upload the necessary information
    def to_jq_upload

      {
        "name" => self.spec_file_name,
        "size" => self.spec_file_size,
        "url" => self.url("original", 1.day),
        "thumbnail_url" => self.url("mini"),
        "delete_url" => "/airframe_specs/#{id}",
        "delete_type" => "DELETE",
        "is_thumbnail" => self.thumbnail,
        "id" => self.id
      }

    end

end