require 'spec_helper'

describe AirframeMessage do

  it "can be created" do
    FactoryGirl.create(:airframe_message).should be_valid
  end
  it "can be sent to contact" do
    ActionMailer::Base.deliveries = []
    message = FactoryGirl.create(:airframe_message)
    message.send_message
    ActionMailer::Base.deliveries.should_not be_empty
    ActionMailer::Base.deliveries.last.to.first.should == message.recipient.email
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
  it "cannot be sent without user activation" do
    ActionMailer::Base.deliveries = []
    message = FactoryGirl.create(:airframe_message)
    message.creator.activated = false
    message.send_message.should == false
    ActionMailer::Base.deliveries.should be_empty
  end
  it "generates a valid photos url on creation" do
    FactoryGirl.create(:airframe_message).photos_url_code.should_not be_blank
  end
  it "generates a valid spec url on creation" do
    FactoryGirl.create(:airframe_message).spec_url_code.should_not be_blank
  end
  it "shows photos link in email if this.photos_enabled is true" do
    message = FactoryGirl.create(:airframe_message, :photos_enabled => true)
    ActionMailer::Base.deliveries = []
    message.send_message
    ActionMailer::Base.deliveries.should_not be_empty
    ActionMailer::Base.deliveries.last.content.match(/"href='\/p\/(.*?)'"/).should_not be_empty
  end
  it "does not send specs that are disabled" do
    spec = FactoryGirl.create(:airframe_spec, :enabled => false)
    spec.enabled = false
    message = FactoryGirl.create(:airframe_message, :airframe_spec => spec)
    ActionMailer::Base.deliveries = []
    message.send_message.should == false
    ActionMailer::Base.deliveries.should be_empty
  end
  it "shows 'Sending' status and date when message is sent" do
    message = FactoryGirl.create(:airframe_message)
    message.send_message
    message.status.should == "Sending"
    (message.status_date < Time.now() && message.status_date > 5.minutes.ago).should == true
  end
  ## other status codes tested in request specs
  ## (status is from SendGrid webhook callback)
  it "hides photos link in email if this.photos_enabled is false" do
    message = FactoryGirl.create(:airframe_message, :photos_enabled => false)
    ActionMailer::Base.deliveries = []
    message.send_message
    ActionMailer::Base.deliveries.should_not be_empty
    ActionMailer::Base.deliveries.last.content.match(/"href='\/p\/(.*?)'"/).should be_empty
  end
  it "hides spec link in email if this.spec_enabled is false" do
    message = FactoryGirl.create(:airframe_message, :spec_enabled => false)
    ActionMailer::Base.deliveries = []
    message.send_message
    ActionMailer::Base.deliveries.should_not be_empty
    ActionMailer::Base.deliveries.last.content.match(/"href='\/s\/(.*?)'"/).should be_empty
  end
  it "does not require a spec to be associated" do
    FactoryGirl.create(:airframe_message, :airframe_spec => nil).should be_valid
  end
end
