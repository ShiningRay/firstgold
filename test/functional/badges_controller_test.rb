# -*- encoding : utf-8 -*-
require 'test_helper'

class BadgesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:badges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create badge" do
    assert_difference('Badge.count') do
      post :create, :badge => { }
    end

    assert_redirected_to badge_path(assigns(:badge))
  end

  test "should show badge" do
    get :show, :id => badges(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => badges(:one).id
    assert_response :success
  end

  test "should update badge" do
    put :update, :id => badges(:one).id, :badge => { }
    assert_redirected_to badge_path(assigns(:badge))
  end

  test "should destroy badge" do
    assert_difference('Badge.count', -1) do
      delete :destroy, :id => badges(:one).id
    end

    assert_redirected_to badges_path
  end
end
