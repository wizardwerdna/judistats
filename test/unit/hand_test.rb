require 'test_helper'

class HandTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Hand.new.valid?
  end
end
