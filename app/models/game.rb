class Game < ActiveRecord::Base
  belongs_to :game_type
  belongs_to :season
  belongs_to :field
  belongs_to :home_team, :class_name => "Team", :foreign_key => 'home_team_id'
  belongs_to :away_team, :class_name => "Team", :foreign_key => 'away_team_id'
  after_save :clear_standings

  # Force the standings to be recalculated by deleting the current standings.
  def clear_standings
    Standing.delete_all(["season_id = ? and game_type_id = ?", self.season_id, self.game_type_id])
  end
end
