require 'test_helper'

class HandsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Hand.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Hand.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Hand.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to hand_url(assigns(:hand))
  end
  
  def test_edit
    get :edit, :id => Hand.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Hand.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Hand.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Hand.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Hand.first
    assert_redirected_to hand_url(assigns(:hand))
  end
  
  def test_destroy
    hand = Hand.first
    delete :destroy, :id => hand
    assert_redirected_to hands_url
    assert !Hand.exists?(hand.id)
  end
end
