require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    player = Player.new
    assert !player.save, "Saved player with no name and team"
 
    player = Player.new(:name => "John Doe")
    assert !player.save, "Saved player with no team"

    player = Player.new(:team_id => 1)
    assert !player.save, "Saved player with no name"

    player = Player.new(:name => "John Doe", :team_id => 1)
    assert player.save, "Could not save player"

  end
end
