require 'spec_helper'

describe Contact do

  it "can be created" do
    FactoryGirl.build(:contact).should be_valid
  end

  it "can have notes" do
    contact = FactoryGirl.build(:contact)
    note = Note.create(:notable => contact)
    contact.notes << note
    contact.notes.first.should == note
  end

  it "can have todos" do
    contact = FactoryGirl.build(:contact)
    todo = Todo.create(:actionable => contact)
    contact.todos << todo
    contact.todos.first.should == todo
  end

  it "can have leads" do
    contact = FactoryGirl.build(:contact)
    lead = Lead.create(
      :airframe => FactoryGirl.build(:airframe),
      :creator => FactoryGirl.build(:user)
    )
    contact.leads << lead
    contact.leads.first.should == lead
  end

  it "requires website url be valid" do
    FactoryGirl.build(:contact, :website => "^").should_not be_valid
    FactoryGirl.build(:contact, :website => Faker::Lorem.word).should_not be_valid
  end

  it "can have valid website url" do
    FactoryGirl.build(:contact, :website => "http://www.jetdeck.co").should be_valid
    FactoryGirl.build(:contact, :website => Faker::Internet.url).should be_valid
  end

  it "must belong to an owner XOR have a user" do
    FactoryGirl.build(:contact, :user => nil, :owner => nil).should_not be_valid
    FactoryGirl.build(:contact,
                      :user => FactoryGirl.build(:user),
                      :owner => FactoryGirl.build(:user)).should_not be_valid
  end

  it "can have messages received" do
    contact = FactoryGirl.build(:contact)
    message = FactoryGirl.build(:airframe_message, :recipient => nil)
    contact.messages_received << message
    contact.messages_received.first.should == message
  end

  it "has a valid email field output" do
    contact = FactoryGirl.build(:contact)
    contact.emailField.match(contact.email).should_not == nil
  end

  it "requires an email address" do
    FactoryGirl.build(:contact, :email => nil).should_not be_valid
  end

  xit "requires email address have a confirmation" do
  end

  xit "has a unique email address per contact in user address book" do
  end

  xit "has a valid full name" do
  end

  it "can be converted to a string" do
    FactoryGirl.build(:contact).to_s.should_not == nil
  end

end
