require 'test_helper'

class FormulasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formulas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formula" do
    assert_difference('Formula.count') do
      post :create, :formula => { }
    end

    assert_redirected_to formula_path(assigns(:formula))
  end

  test "should show formula" do
    get :show, :id => formulas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => formulas(:one).to_param
    assert_response :success
  end

  test "should update formula" do
    put :update, :id => formulas(:one).to_param, :formula => { }
    assert_redirected_to formula_path(assigns(:formula))
  end

  test "should destroy formula" do
    assert_difference('Formula.count', -1) do
      delete :destroy, :id => formulas(:one).to_param
    end

    assert_redirected_to formulas_path
  end
end
