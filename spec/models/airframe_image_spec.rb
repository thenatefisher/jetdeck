require 'spec_helper'
require 'support/create_file_helper'

describe AirframeImage do
  include CreateFileHelper

  before(:each) do 
    # dont actually upload to s3
    AirframeSpec.any_instance.stub(:save_attached_files).and_return(true)     
  end
 
  it "can be created" do
    FactoryGirl.build(:airframe_image).should be_valid         
  end

  it "is required to have a creator" do
    FactoryGirl.build(:airframe_image, :creator => nil).should_not be_valid        
  end

  it "is required to have an airframe" do
    FactoryGirl.build(:airframe_image, :airframe => nil).should_not be_valid        
  end

  it "responds to jq upload ui" do
    FactoryGirl.create(:airframe_image, :airframe => Airframe.new()).to_jq_upload.should_not be_blank
  end

  it "must have a file attachment as image" do
    FactoryGirl.build(:airframe_image, :image => nil).should_not be_valid        
  end  

  it "is not created if file would exceed account quota" do
    # create a file that is larger than the user account quota
    file_handler = create_image_file("png", 5000)
    # make a user with a smaller quota to fail
    user = FactoryGirl.create(:user, :storage_quota => 4999)
    # try and make a spec
    FactoryGirl.build(:airframe_image, :creator => user, :image => file_handler).should_not be_valid 
  end

  it "requires image file to be png, jpg, tga, bmp, targa or gif format" do
    file_handler = create_image_file("wav")
    FactoryGirl.build(:airframe_image, :image => file_handler).should_not be_valid 
  end 

  it "allows image file to be png format" do
    file_handler = create_image_file("jpg")
    FactoryGirl.build(:airframe_image, :image => file_handler).should be_valid 
  end  

  it "requires image file to be under 5 Mb" do
    one_meg = 1048576
    file_handler = create_image_file("png", one_meg*5)
    FactoryGirl.build(:airframe_image, :image => file_handler).should_not be_valid     
  end

  it "allows image file to be under 5 Mb" do
    one_meg = 1048576
    file_handler = create_image_file("png", one_meg*5-1)
    FactoryGirl.build(:airframe_image, :image => file_handler).should be_valid     
  end      

  it "provide an AWS S3 url for image" do
    FactoryGirl.build(:airframe_image).url.should_not be_blank  
  end
  
end
