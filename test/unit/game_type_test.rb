require 'test_helper'

class GameTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    game_type = GameType.new
    assert !game_type.save, "Saved game_type with no name"
 
    game_type = GameType.new(:name => "New type")
    assert game_type.save, "Could not save game_type"

    game_type2 = GameType.new(:name => "New type")
    assert !game_type2.save, "Saved duplicate game_type"

  end
end
