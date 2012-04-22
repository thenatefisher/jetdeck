require 'test_helper'

class AirframeTest < ActiveSupport::TestCase

  test "should not save airframe without arguments" do
    a = Airframe.new()
    assert !a.save
  end

  test "should store and display avionics" do
    af = FactoryGirl.build(:airframe)
    av = FactoryGirl.build(:avionic)
    af.avionics << av
    assert_equal af.avionics.first, av
  end

  test "should store and display engines" do
    af = FactoryGirl.build(:airframe)
    engine = FactoryGirl.build(:engine)
    af.engines << engine
    assert_equal af.engines.first, engine
  end

  test "should store and display equipment" do
    assert false
  end

  test "should store and display interiors" do
    assert false
  end

  test "should store and display exteriors" do
    assert false
  end

  test "should store and display modifications" do
    assert false
  end

  test "should destroy specs on destroy" do
    assert false
  end

  test "should record change history for registration" do
    assert false
  end
  
  test "should record change history for market status" do
    assert false
  end  

  test "should require a model name before save" do
    af = FactoryGirl.build(:airframe)
    af.m.destroy
    assert !af.save
  end

  test "should be able to create many xspecs" do
    assert false
  end
  
  test "should be able to share with other users" do
    assert false
  end

  test "should calculate credit value" do
    assert false
  end

end
