require 'test_helper'

class SummaryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Summary.new.valid?
  end
end
