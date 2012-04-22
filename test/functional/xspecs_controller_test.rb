require 'test_helper'

class XspecsControllerTest < ActionController::TestCase
  setup do
    @xspec = xspecs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:xspecs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spec" do
    assert_difference('Xspec.count') do
      post :create, :xspec => @xspec.attributes
    end

    assert_redirected_to xspec_path(assigns(:xspec))
  end

  test "should show spec" do
    get :show, :id => @xspec
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @xspec
    assert_response :success
  end

  test "should update spec" do
    put :update, :id => @xspec, :xspec => @xspec.attributes
    assert_redirected_to xspec_path(assigns(:xspec))
  end

  test "should destroy spec" do
    assert_difference('Xspec.count', -1) do
      delete :destroy, :id => @xspec
    end

    assert_redirected_to xspecs_path
  end
end
