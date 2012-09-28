class Game < ActiveRecord::Base
  validates :season_id, :presence => true, :numericality => true
  validates :time, :presence => true
  validates :field_id, :presence => true
  validates :game_type_id, :presence => true
  belongs_to :game_type
  belongs_to :season
  belongs_to :field
  belongs_to :home_team, :class_name => "Team", :foreign_key => 'home_team_id'
  belongs_to :away_team, :class_name => "Team", :foreign_key => 'away_team_id'
  after_save :clear_standings

  # Force the standings for current season to be recalculated by deleting the current standings.
  def clear_standings
    if season.current
      Standing.delete_all(["season_id = ? and game_type_id = ?", self.season_id, self.game_type_id])
    end
  end

  def game_time
    begin
      game_end = time.strftime("%Y%m%d") == self.until.strftime("%Y%m%d") ? self.until.strftime("%H:%M") : self.until.to_s(:short)
      " #{time.to_s(:short)} - #{game_end}" 
    rescue
      time.to_s(:short) 
    end
  end
end
