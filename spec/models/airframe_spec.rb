require 'spec_helper'

describe Airframe do

  before(:each) do
    # dont actually upload to s3
    AirframeSpec.any_instance.stub(:save_attached_files).and_return(true)
  end

  it "can be created" do
    FactoryGirl.build(:airframe).should be_valid
  end

  it "can have images" do
    airframe = FactoryGirl.build(:airframe)
    image = AirframeImage.create(
      :creator => FactoryGirl.create(:user),
      :image => File.new("spec/fixtures/favicon.png")
    )
    airframe.images << image
    airframe.images.first.should == image
  end

  it "can have specs" do
    airframe = FactoryGirl.create(:airframe)
    spec = AirframeSpec.create(
      :creator => FactoryGirl.create(:user),
      :spec => File.new("spec/fixtures/f1040.pdf")
    )
    airframe.specs << spec
    airframe.specs.first == spec
  end

  it "can have todos" do
    airframe = FactoryGirl.build(:airframe)
    todo = Todo.create(:actionable => airframe)
    airframe.todos << todo
    airframe.todos.first.should == todo
  end

  it "can have notes" do
    airframe = FactoryGirl.build(:airframe)
    note = Note.create(:notable => airframe)
    airframe.notes << note
    airframe.notes.first.should == note
  end

  it "can have leads" do
    airframe = FactoryGirl.build(:airframe)
    lead = Lead.create(
      :contact => FactoryGirl.build(:contact),
      :creator => FactoryGirl.build(:user)
    )
    airframe.leads << lead
    airframe.leads.first.should == lead
  end

  it "has a creator" do
    FactoryGirl.build(:airframe, :creator => nil).should_not be_valid
    FactoryGirl.build(:airframe).creator.should be_valid
  end

  it "has a long response that matches details" do
    year = rand(55) + 1960
    make = Faker::Company.name
    model_name = Faker::Name.last_name
    serial = "#{Faker::Lorem.word.upcase} #{rand(999999)}"
    registration = Faker::Lorem.word.upcase
    airframe = FactoryGirl.build(:airframe,
                                 :year => year,
                                 :make => make,
                                 :model_name => model_name,
                                 :serial => serial,
                                 :registration => registration
                                 )
    airframe.long.match(/#{year}/).should_not == nil
    airframe.long.match(/#{model_name}/).should_not == nil
    airframe.long.match(/#{make}/).should_not == nil
    airframe.long.match(/#{serial}/).should_not == nil
    airframe.long.match(/#{registration}/).should_not == nil
  end

  it "has a to_s response that matches details" do
    year = rand(55) + 1960
    make = Faker::Company.name
    model_name = Faker::Name.last_name
    airframe = FactoryGirl.build(:airframe,
                                 :year => year,
                                 :make => make,
                                 :model_name => model_name
                                 )
    airframe.to_s.match(/#{year}/).should_not == nil
    airframe.to_s.match(/#{model_name}/).should_not == nil
    airframe.to_s.match(/#{make}/).should_not == nil
  end

  it "has at least one thumbnail if images exist" do
    airframe = FactoryGirl.build(:airframe)
    image = AirframeImage.create(
      :creator => FactoryGirl.create(:user),
      :image => File.new("spec/fixtures/favicon.png")
    )
    image.thumbnail.should_not == true
    airframe.images << image
    image.thumbnail.should == true
  end

  it "has an avatar with all image style urls if thumbnail exists" do
    airframe = FactoryGirl.create(:airframe)
    image = AirframeImage.create(
      :creator => FactoryGirl.create(:user),
      :image => File.new("spec/fixtures/favicon.png")
    )
    airframe.images << image
    airframe.avatar.should include(:original)
    airframe.avatar.should include(:listing)
    airframe.avatar.should include(:mini)
    airframe.avatar.should include(:thumb)
  end

end
