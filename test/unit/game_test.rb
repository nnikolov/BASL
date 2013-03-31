require 'test_helper'

class GameTest < ActiveSupport::TestCase
  fixtures :seasons
  fixtures :fields
  fixtures :game_types
  # test "the truth" do
  #   assert true
  # end

  test "create new game" do
    game = Game.new(:field => fields(:hn1), :time => "2013-05-30", :game_type => game_types(:season))
    assert !game.save, "Saved game without season"

    game = Game.new(:season => seasons(:winter), :time => "2013-05-30", :game_type => game_types(:season))
    assert !game.save, "Saved game without field"

    game = Game.new(:season => seasons(:winter), :field => fields(:hn1), :game_type => game_types(:season))
    assert !game.save, "Saved game without time"

    game = Game.new(:season => seasons(:winter), :field => fields(:hn1), :time => "2013-05-30")
    assert !game.save, "Saved game without game_type"

    game = Game.new(:season => seasons(:winter), :field => fields(:hn1), :time => "2013-05-30", :game_type => game_types(:season))
    assert game.save, "Could not save game with blank scores"

    game.home_team_score = 1
    game.away_team_score = 1
    assert game.save, "Could not save game with integer scores"
  end
end
