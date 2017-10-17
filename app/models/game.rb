class Game < ActiveRecord::Base
  validates :season_id, :presence => true, :numericality => true
  validates :time, :presence => true
  validates :field_id, :presence => true, :numericality => true, :uniqueness => { :scope => :time }
  validates :game_type_id, :numericality => true, :presence => true
  validates :home_team_score, :numericality => { :only_integer => true }, :allow_nil => true
  validates :away_team_score, :numericality => { :only_integer => true }, :allow_nil => true
  belongs_to :game_type
  belongs_to :season
  belongs_to :field
  belongs_to :home_team, :class_name => "Team", :foreign_key => 'home_team_id'
  belongs_to :away_team, :class_name => "Team", :foreign_key => 'away_team_id'
  after_save :clear_standings

  def self.next_games
    Game.where(["time >= ? and time <= ?", Game.next_game_time, Game.next_game_time + 1.day])
    rescue
      []
  end

  def self.next_game_time
    Game.where(["time > ?", Time.now]).order(:time).first.time
    rescue
      nil
  end

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
