require 'test_helper'

class SummariesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Summary.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Summary.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Summary.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to summary_url(assigns(:summary))
  end
  
  def test_edit
    get :edit, :id => Summary.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Summary.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Summary.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Summary.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Summary.first
    assert_redirected_to summary_url(assigns(:summary))
  end
  
  def test_destroy
    summary = Summary.first
    delete :destroy, :id => summary
    assert_redirected_to summaries_url
    assert !Summary.exists?(summary.id)
  end
end
