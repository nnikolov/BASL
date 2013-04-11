class CalculatePlayoffRank < ActiveRecord::Migration
  def up
    seasons = [1, 3, 7, 8, 9, 10, 11, 12]
    game_type = GameType.find_by_name("Playoff")
    seasons.each do |season_id|
      Standing.playoff_rank(season_id, game_type)
    end
  end

  def down
    seasons = [1, 3, 7, 8, 9, 10, 11, 12]
    game_type = GameType.find_by_name("Playoff")
    seasons.each do |season_id|
      Standing.where(:season_id => season_id, :game_type_id => game_type.id, :cached => true).each do |standing|
        standing.rank = 6
        standing.save
      end
    end
  end
end
