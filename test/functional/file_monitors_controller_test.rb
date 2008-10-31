require 'test_helper'

class FileMonitorsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => FileMonitor.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    FileMonitor.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    FileMonitor.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to file_monitor_url(assigns(:file_monitor))
  end
  
  def test_edit
    get :edit, :id => FileMonitor.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    FileMonitor.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FileMonitor.first
    assert_template 'edit'
  end
  
  def test_update_valid
    FileMonitor.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FileMonitor.first
    assert_redirected_to file_monitor_url(assigns(:file_monitor))
  end
  
  def test_destroy
    file_monitor = FileMonitor.first
    delete :destroy, :id => file_monitor
    assert_redirected_to file_monitors_url
    assert !FileMonitor.exists?(file_monitor.id)
  end
end
