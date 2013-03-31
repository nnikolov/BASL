require 'test_helper'

class SeasonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "invalid with empty attributes" do
    season = Season.new
    assert !season.valid?
    assert !season.save, "Saved the season without name and start date"
  end

  test "create new season" do
    season = Season.new(:name => "Summer", :start_date => "2013-05-30")
    assert season.save, "Could not save season"
  end
end
