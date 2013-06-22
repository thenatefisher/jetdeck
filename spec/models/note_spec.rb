require 'spec_helper'

describe Note do

  it "can be created" do
  	FactoryGirl.build(:contact_note).should be_valid 
  	FactoryGirl.build(:airframe_note).should be_valid 
  end
  
  it "requires a description be entered" do
 	FactoryGirl.build(:airframe_note, :description => nil).should_not be_valid 
 	FactoryGirl.build(:contact_note, :description => nil).should_not be_valid 
  end

  it "can be attached to a contact" do 
  	contact = FactoryGirl.build(:contact)
        contact.notes << FactoryGirl.build(:note)
	contact.notes.count.should == 1
  end

  xit "can be attached to an airframe" do 
        airframe = FactoryGirl.build(:airframe)
        airframe.notes << FactoryGirl.build(:note)
	airframe.notes.count.should == 1
  end

  xit "is deleted with its parent" do
  end

end
