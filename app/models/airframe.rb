class Airframe < ActiveRecord::Base

  # relationships
  has_many :actions, :as => :actionable
  has_many :notes, :as => :notable
  
  belongs_to :airport

  has_many    :engines,
              :foreign_key => "airframe_id",
              :class_name => "Engine"
              
  has_many    :equipment,
              :foreign_key => "airframe_id",
              :class_name => "Equipment"              

  has_many :accessories, :dependent => :destroy

  accepts_nested_attributes_for :accessories, :reject_if => lambda { |t| t['image'].nil? }

  accepts_nested_attributes_for :engines, :allow_destroy => true
  
  accepts_nested_attributes_for :equipment, :allow_destroy => true
  
  has_many :xspecs, :dependent => :destroy

  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"

  def search_url
    "/airframes/#{id}"
  end
  
  def search_desc
    self.to_s
  end
  
  def search_label
    label = self.serial
    if self.registration.present? && self.serial.present?
      label += " (#{self.registration.upcase})"
    else
      label = self.registration.upcase
    end
   
    label = "<i class=\"icon-plane\"></i> #{label}"
     
  end
  
  def avatar

    avatars = Hash.new()
    assy = accessories.where(:thumbnail => true).first
    if assy.present?

        { :original => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket + 
            "/images/#{assy.id}/original/#{assy.image_file_name}",
          :listing => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket +
            "/images/#{assy.id}/listing/#{assy.image_file_name}",
          :mini => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket +
            "/images/#{assy.id}/mini/#{assy.image_file_name}",
          :thumb => 
            "https://s3.amazonaws.com/" +
            Jetdeck::Application.config.aws_s3_bucket +
            "/images/#{assy.id}/thumb/#{assy.image_file_name}" }

    end

  end

  def to_s
    retval =   ''
    retval +=  self.year.to_s + " " if self.year
    retval +=  self.make + " " if self.make
    retval +=  self.model_name if self.model_name
    retval
  end

end
