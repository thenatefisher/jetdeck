require 'spec_helper'

describe AirframeImage do

  it "is required to have a creator" do
    FactoryGirl.build(:airframe_image, :creator => nil).should_not be_valid        
  end

  it "is required to have an airframe" do
    FactoryGirl.build(:airframe_image, :airframe => nil).should_not be_valid        
  end

  it "responds to jq upload ui" do
    af_image = FactoryGirl.create(:airframe_image)
    af_image.to_jq_upload != nil
  end

  it "must have a file attachment as image" do
    FactoryGirl.build(:airframe_image, :image => nil).should_not be_valid        
  end  

  it "is not created if file would exceed account quota" do

    tmpfilename = Faker::Internet.domain_word + "_5000_padding.png"
    tmpfilepath = File::join(Rails.root, "tmp", tmpfilename)
    favicon = File::join(Rails.root, "spec", "fixtures", "favicon.png")
    `dd if=/dev/zero of=#{tmpfilepath} bs=5000 count=1`
    `dd if=#{favicon} of=#{tmpfilepath} conv=notrunc`

    user = FactoryGirl.create(:user, :storage_quota => 4999)

    file = File::open(tmpfilepath)
    FactoryGirl.create(:airframe_image, :creator => user, :image => file).should_not be_valid      
    File::delete(tmpfilepath) if File::exists?(tmpfilepath)

  end

  xit "requires image file to be png, jpg, tga, bmp, targa or gif format" do
  end 

  xit "allows image file to be png, jpg, tga, bmp, targa or gif format" do
  end  

  xit "requires image file to be under 5 Mb" do
  end      

  xit "provide an AWS S3 url for image" do
  end
  
end
