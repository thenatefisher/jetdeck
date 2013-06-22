require 'spec_helper'

describe Invite do
	
  it "can be created" do
  	FactoryGirl.build(:invite).should be_valid 
  end

end
