class AirframeImage < ActiveRecord::Base

  attr_protected :image_file_name, :image_content_type, :image_file_size

  belongs_to :airframe
  validates_associated :airframe
  validates_presence_of :airframe

  belongs_to :creator, :foreign_key => :created_by, :class_name => "User"
  validates_associated :creator
  validates_presence_of :creator

  has_attached_file :image,
    :styles => {  :thumb => "140x130#", # displayed on show page
                  :mini => "80x60#", # on show page in picture list
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
  validates_attachment_size :image, :less_than => 20.megabytes
  validates_presence_of :image
  validates_attachment_content_type :image, :content_type =>
    ["image/png",
     "image/jpg",
     "image/jpeg",
     "image/tga",
     "image/bmp",
     "image/targa",
     "image/gif"]
  validate :validate_space_available, :on => :create

  before_destroy :next_thumbnail

  before_create :init

  def init
    self.thumbnail = true if self.airframe && self.airframe.images.empty?
    self.thumbnail ||= false
    nil
  end

  # do not edit/create if user is delinquent
  validate :creator_account_current, :on => :create
  def creator_account_current
    if self.creator && self.creator.delinquent?
      self.errors.add :base, "Your account is not current. Please update subscription payment information."
    end
  end
  
  # do not create a spec if use is over quota
  def validate_space_available
    if image_file_size.blank?
      self.errors.add :image, "file is not valid"
    elsif self.creator && ((self.creator.storage_usage + self.image_file_size) >= self.creator.storage_quota)
      self.errors.add :image, "exceeds account storage allowance"
    end
  end

  # select another thumbnail if it is deleted or none available for the airframe
  def next_thumbnail
    if self.thumbnail
      new_thumb = self.airframe.images.where("image_file_name IS NOT null AND thumbnail = 'f'").first
      if new_thumb
        new_thumb.thumbnail = true
        new_thumb.save()
      end
    end
  end

  # one convenient method to get an AWS s3 url
  def url(style="original", expires_in=30.minutes)
    self.image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
  end

  # one convenient method to pass jq_upload the necessary information
  def to_jq_upload

    ajax_response = {
      "name" => self.image_file_name,
      "size" => self.image_file_size,
      "url" => self.url("original", 1.day),
      "thumbnail_url" => self.url("mini"),
      "delete_url" => "/airframe_images/#{id}",
      "delete_type" => "DELETE",
      "is_thumbnail" => self.thumbnail,
      "id" => self.id
    }
    ajax_response.merge!({"error" => self.errors.full_messages}) if !self.errors.messages.empty?
    return ajax_response

  end

end
