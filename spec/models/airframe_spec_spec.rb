require 'spec_helper'
require 'support/create_file_helper'

describe AirframeSpec do
  include CreateFileHelper

  before(:each) do 
    # dont actually upload to s3
    AirframeSpec.any_instance.stub(:save_attached_files).and_return(true)     
  end

  it "can be created" do
    FactoryGirl.create(:airframe_spec).should be_valid
  end

  it "is required to have a creator" do
    FactoryGirl.build(:airframe_spec, :creator => nil).should_not be_valid
  end

  it "is required to have an airframe" do
    FactoryGirl.build(:airframe_spec, :airframe => nil).should_not be_valid  
  end

  it "is enabled by default" do 
    FactoryGirl.build(:airframe_spec).enabled.should == true
  end

  it "cannot be emailed if disabled" do
    ActionMailer::Base.deliveries = []
    spec = FactoryGirl.create(:airframe_spec, :enabled => false)
    message = FactoryGirl.create(:airframe_message, :airframe_spec => spec)
    message.send_message
    ActionMailer::Base.deliveries.should == []
  end

  it "responds to jq upload ui" do
      FactoryGirl.build(:airframe_spec).to_jq_upload.should_not be_blank
  end

  it "must have a file attachment as spec" do
    FactoryGirl.build(:airframe_spec, :spec => nil).should_not be_valid  
  end  

  it "is not created if file would exceed account quota" do
    # create a file that is larger than the user account quota
    file_handler = create_file("pdf", 5000)
    # make a user with a smaller quota to fail
    user = FactoryGirl.create(:user, :storage_quota => 4999)
    # try and make a spec
    FactoryGirl.build(:airframe_spec, :creator => user, :spec => file_handler).should_not be_valid      
  end

  it "rejects files without pdf, docx or doc extension" do
    # create a file that is of invalid file extension
    file_handler = create_file("wav")
    # try and make a spec
    FactoryGirl.build(:airframe_spec, :spec => file_handler).should_not be_valid 
  end  

  it "allows spec file to have pdf extension" do
    # create a file that is of valid file extension
    file_handler = create_file("pdf")
    # try and make a spec
    FactoryGirl.build(:airframe_spec, :spec => file_handler).should be_valid 
  end  

  it "allows spec file to be doc extension" do
    # create a file that is of valid file extension
    file_handler = create_file("doc")
    # try and make a spec
    FactoryGirl.build(:airframe_spec, :spec => file_handler).should be_valid 
  end  

  it "allows spec file to be docx extension" do
    # create a file that is of valid file extension
    file_handler = create_file("docx")
    # try and make a spec
    FactoryGirl.build(:airframe_spec, :spec => file_handler).should be_valid 
  end  

  it "does not allow spec file to be 10Mb or over" do
    ten_meg = 10485760
    # create a file that is of valid file extension
    # and invalid size
    file_handler = create_file("docx", ten_meg)
    # try and make a spec
    FactoryGirl.build(:airframe_spec, :spec => file_handler).should_not be_valid 
  end      

  it "allows spec file to be within 10Mb" do
    ten_meg = 10485760
    # create a file that is of valid file extension
    # and valid size
    file_handler = create_file("docx", ten_meg-1)
    # try and make a spec
    FactoryGirl.build(:airframe_spec, :spec => file_handler).should be_valid 
  end 

  it "provide an AWS S3 url for spec" do
    FactoryGirl.build(:airframe_spec).url.should_not be_blank  
  end

end
