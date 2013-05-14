require File.dirname(__FILE__) + '/../test_helper'

class ScenarioTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :scenarios
  def setup
    @scenario = Scenario.find(1)
  end

  def test_truth
    assert_kind_of Scenario, @scenario
  end
end
