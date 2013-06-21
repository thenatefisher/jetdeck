require 'spec_helper'

describe Todo do

  it "can be created" do
  	FactoryGirl.build(:airframe_todo).should be_valid 
  	FactoryGirl.build(:contact_todo).should be_valid 
  end

end
