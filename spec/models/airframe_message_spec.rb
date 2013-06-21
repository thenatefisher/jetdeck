require 'spec_helper'

describe AirframeMessage do

  it "can be created" do
    FactoryGirl.create(:airframe_message).should be_valid
  end

  it "can be sent to contact" do 
    ActionMailer::Base.deliveries = []
    message = FactoryGirl.create(:airframe_message)
    message.send_message
    ActionMailer::Base.deliveries.last.to.should == message.recipient.email
  end

  it "requires an airframe" do
    FactoryGirl.build(:airframe_message, :airframe => nil).should_not be_valid
  end

  it "requires a recipient" do
    FactoryGirl.build(:airframe_message, :recipient => nil).should_not be_valid    
  end

  it "requires a creator" do
    FactoryGirl.build(:airframe_message, :creator => nil).should_not be_valid    
  end

  it "requires a subject" do
    FactoryGirl.build(:airframe_message, :subject => nil).should_not be_valid    
  end

  xit "cannot be sent without user activation" do
  end

  xit "generates a photos url on creation" do
  end

  xit "generates a spec url on creation" do
  end

  xit "does not send specs that are disabled" do
  end

  xit "shows 'Sent' status and date when message is sent" do
  end

  xit "shows 'Opened' status and date when message is opened" do
  end

  xit "shows 'Downloaded' status and date when message is downloaded" do
  end

  xit "shows 'Bounced' status and date when message is bounced" do
  end

  xit "shows 'Unknown' status by default and status date is when created" do
  end  

  xit "can send email" do
  end

  xit "hides photos link in email if this.photos_enabled is false" do
  end
  
  xit "hides spec link in email if this.spec_enabled is false" do
  end

  xit "does not require a spec to be associated" do
  end

end
