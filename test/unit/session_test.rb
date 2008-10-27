require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Session.new.valid?
  end
end
