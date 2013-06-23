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
    note = Note.create(
      :author => FactoryGirl.build(:user),
      :description => "Contact Note"
    )
    contact.notes << note
    contact.notes.first.should == note
  end

  it "can be attached to an airframe" do 
    airframe = FactoryGirl.build(:airframe)
    note = Note.create(
      :author => FactoryGirl.build(:user),
      :description => "Airframe Note"
    )
    airframe.notes << note
    airframe.notes.first.should == note
  end

  it "is deleted with its airframe parent" do
    airframe = FactoryGirl.build(:airframe)
    note = Note.create(
      :author => FactoryGirl.build(:user),
      :description => "Airframe Note"
    )
    airframe.notes << note
    airframe.destroy
    note.should == nil
  end

  it "is deleted with its contact parent" do
    contact = FactoryGirl.build(:contact)
    note = Note.create(
      :author => FactoryGirl.build(:user),
      :description => "Contact Note"
    )
    contact.notes << note
    contact.destroy
    note.should == nil
  end

end
