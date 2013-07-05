require "#{Rails.root}/app/models/lib/airframe_import_cdc"
require "#{Rails.root}/app/models/lib/airframe_import_aso"

class Airframe < ActiveRecord::Base

  extend AirframeImport

  # relationships
  has_many :todos, :foreign_key => :actionable_id, :as => :actionable, :dependent => :destroy
  accepts_nested_attributes_for :todos

  has_many :notes, :as => :notable, :dependent => :destroy
  accepts_nested_attributes_for :notes

  has_many :images, :class_name => "AirframeImage", :conditions => "image_file_name is not null", :dependent => :destroy
  accepts_nested_attributes_for :images

  has_many :specs, :class_name => "AirframeSpec", :conditions => "spec_file_name is not null", :dependent => :destroy
  accepts_nested_attributes_for :specs

  has_many :leads, :dependent => :destroy

  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  validates_associated :creator
  validates_presence_of :creator

  # static method to create a new airframe from listing URL
  def self.import(user_id=nil, link=nil)

    # require a url and owner
    return nil if link.blank? || user_id.blank? || User.find(user_id).blank?

    # if already imported...
    airframe = Airframe.where(:created_by => user_id, :import_url => link).first
    return airframe if airframe.present?

    # switch to correct parser
    case link
    when /[www\.]?controller\.com/
      airframe = delay.import_cdc(user_id, link)
    when /[www\.]?aso\.com/
      airframe = delay.import_aso(user_id, link)
    else
      airframe = nil
    end

    return airframe

  end

  # the aircraft default thumbnail
  def avatar
    image = images.where(:thumbnail => true).first 
    if image.present?
    { :original => image.url("original"),
      :listing => image.url("listing"),
      :mini => image.url("mini"),
      :thumb => image.url("thumb") }
    end
  end

  def to_s
    retval =   ""
    retval +=  self.year.to_s + " " if self.year.present?
    retval +=  self.make + " " if self.make.present?
    retval +=  self.model_name if self.model_name.present?
    retval if retval.present? else "Unidentified Aircraft"
  end

  def long
    retval =   ""
    retval +=  self.year.to_s + " " if self.year.present?
    retval +=  self.make + " " if self.make.present?
    retval +=  self.model_name if self.model_name.present?
    retval +=  " SN:#{self.serial}" if self.serial.present?
    retval +=  " (#{self.registration})" if self.registration.present?
    retval if retval.present? else "Unidentified Aircraft"
  end

end
