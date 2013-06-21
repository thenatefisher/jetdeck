require 'spec_helper'

describe Contact do
 
  it "can be created" do
  	FactoryGirl.build(:contact).should be_valid 
  end

  xit "..." do
  end
  
end
