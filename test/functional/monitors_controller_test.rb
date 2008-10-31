require 'test_helper'

class MonitorsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Monitor.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Monitor.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Monitor.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to monitor_url(assigns(:monitor))
  end
  
  def test_edit
    get :edit, :id => Monitor.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Monitor.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Monitor.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Monitor.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Monitor.first
    assert_redirected_to monitor_url(assigns(:monitor))
  end
  
  def test_destroy
    monitor = Monitor.first
    delete :destroy, :id => monitor
    assert_redirected_to monitors_url
    assert !Monitor.exists?(monitor.id)
  end
end
