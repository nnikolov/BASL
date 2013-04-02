require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    assert !Team.new(:name => "White", :color => "white").save, "Saved team with no season_id"

    assert !Team.new(:name => "White", :season_id => 1).save, "Saved team with no color"

    assert !Team.new(:color => "white", :season_id => 1).save, "Saved team with no name"

    assert Team.new(:name => "White", :color => "white", :season_id => 1).save, "Could not save team"
  end
end
