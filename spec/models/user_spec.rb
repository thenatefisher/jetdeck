require 'spec_helper'

describe User do

  it "can be created" do
    FactoryGirl.build(:user).should be_valid
  end

  xit "can be creator of airframe_specs" do

  end

  xit "can be creator of airframe_images" do

  end

  xit "limits default file storage to 100Mb" do

  end

  xit "can be creator of airframes" do

  end

  xit "can be creator of contacts" do

  end

  xit "be creator of todos" do

  end

  xit "requires a unqiue contact associated via contact_id" do

  end

  xit "requires password confirmation on update only" do

  end

  xit "is enabled on creation" do

  end

  xit "is not activated on creation" do

  end

  xit "can send invites" do

  end

  xit "decrements invite count when one is sent" do

  end

  xit "limits default invite count to 10" do

  end

  xit "cannot send more invites than it has available" do

  end

  xit "has unique auth token on creation" do

  end

  xit "has unique bookmarklet token on creation" do

  end

  xit "has unique activation token on creation" do

  end

  xit "can be authenticated when enabled" do

  end

  xit "cannot be authenticated when disabled" do

  end

  xit "can be activated" do

  end

  xit "generates unique password reset token" do

  end

  xit "saves the time a password reset was sent" do

  end

  xit "delivers password reset email to user" do

  end

  xit "can have password reset via correct reset token" do

  end

  xit "must have a unique email address" do

  end

  xit "can have the same email address as another user's contacts" do

  end

end
