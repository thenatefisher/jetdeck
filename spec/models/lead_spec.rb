require 'spec_helper'

describe Lead do

  it "can be created" do
  	FactoryGirl.build(:lead).should be_valid 
  end
  
end
