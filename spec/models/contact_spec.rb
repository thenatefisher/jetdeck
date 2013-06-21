require 'spec_helper'

describe Contact do
 
  it "can be created" do
  	FactoryGirl.build(:contact).should be_valid 
  end

  xit "can have notes" do
  end

  xit "can have todos" do
  end

  xit "can have airframes" do
  end

  xit "requires website url be valid" do
  end

  xit "does belong to a user" do
  end

  xit "can have messages sent" do
  end
  
  xit "can have messages received" do
  end

  xit "can have leads" do
  end

  xit "has a valid email field output" do
  end

  xit "requires an email address" do
  end

  xit "requires email address have a confirmation" do
  end

  xit "has a unique email address per contact in user address book" do
  end

  xit "has a valid full name"
  end

  xit "can be converted to a string"
  end

end
