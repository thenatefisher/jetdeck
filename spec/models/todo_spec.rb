require 'spec_helper'

describe Todo do

  it "can be created" do
    FactoryGirl.build(:airframe_todo).should be_valid
    FactoryGirl.build(:contact_todo).should be_valid
  end

  it "requires a title be entered" do
    FactoryGirl.build(:airframe_todo, :title => nil).should_not be_valid
    FactoryGirl.build(:contact_todo, :title => nil).should_not be_valid
  end

  xit "can be attached to a contact" do
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
