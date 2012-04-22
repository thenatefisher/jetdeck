require 'test_helper'

class AirframesControllerTest < ActionController::TestCase
  setup do
    @airframe = airframes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:airframes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create airframe" do
    assert_difference('Airframe.count') do
      post :create, :airframe => @airframe.attributes
    end

    assert_redirected_to airframe_path(assigns(:airframe))
  end

  test "should show airframe" do
    get :show, :id => @airframe
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @airframe
    assert_response :success
  end

  test "should update airframe" do
    put :update, :id => @airframe, :airframe => @airframe.attributes
    assert_redirected_to airframe_path(assigns(:airframe))
  end

  test "should destroy airframe" do
    assert_difference('Airframe.count', -1) do
      delete :destroy, :id => @airframe
    end

    assert_redirected_to airframes_path
  end
end
