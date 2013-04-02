require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    assert !Rule.new.save, "Saved a rule with no body"
    assert Rule.new(:body => "test").save, "Could not save rule"
  end
end
