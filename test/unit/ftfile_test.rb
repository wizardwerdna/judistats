require 'test_helper'

class FtfileTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Ftfile.new.valid?
  end
end
