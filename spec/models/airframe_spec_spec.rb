require 'spec_helper'

describe AirframeSpec do

  xit "is required to have a creator" do
  end

  xit "is required to have an airframe" do
  end

  xit "is enabled by default" do 
  end

  xit "can have airframe messages" do
  end

  xit "cannot be emailed if disabled" do
  end

  xit "responds to jq upload ui" do
  end

  xit "must have a file attachment as spec" do
  end  

  it "is not created if file would exceed account quota" do

    tmpfilename = Faker::Internet.domain_word + ".pdf"
    tmpfilepath = File::join(Rails.root, "tmp", tmpfilename)
    `dd if=/dev/zero of=#{tmpfilepath} bs=5000 count=1`

    user = FactoryGirl.create(:user, :storage_quota => 4999)

    file = File::open(tmpfilepath)
    FactoryGirl.build(:airframe_spec, :creator => user, :image => file).should_not be_valid      
    File::delete(tmpfilepath) if File::exists?(tmpfilepath)

  end

  xit "requires spec file to be word or pdf format" do
  end  

  xit "allows spec file to be word or pdf format" do
  end  

  xit "requires spec file to be under 10 Mb" do
  end      

  xit "provide an AWS S3 url for spec" do
  end

end
