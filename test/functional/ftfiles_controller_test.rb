require 'test_helper'

class FtfilesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Ftfile.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Ftfile.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Ftfile.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to ftfile_url(assigns(:ftfile))
  end
  
  def test_edit
    get :edit, :id => Ftfile.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Ftfile.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Ftfile.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Ftfile.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Ftfile.first
    assert_redirected_to ftfile_url(assigns(:ftfile))
  end
  
  def test_destroy
    ftfile = Ftfile.first
    delete :destroy, :id => ftfile
    assert_redirected_to ftfiles_url
    assert !Ftfile.exists?(ftfile.id)
  end
end
