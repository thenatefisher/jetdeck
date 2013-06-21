require 'spec_helper'

describe Note do

  it "can be created" do
  	FactoryGirl.build(:contact_note).should be_valid 
  	FactoryGirl.build(:airframe_note).should be_valid 
  end
  
end
