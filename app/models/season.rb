class Season < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :start_date, :presence => true
  has_many :teams, :order => "name", :dependent => :destroy
  has_many :games, :order => "time, id", :dependent => :destroy
  has_many :players, :through => :teams, :order => :name, :conditions => ["players.active = true"]

  attr_accessor :game_duration
  before_update :update_game_duration

  def before_save
    if self.current # Set all other seasons to not current
      sql = ActiveRecord::Base.connection();
      sql.execute("update seasons set current = 0")
    end
  end

  def update_game_duration
    unless self.game_duration.blank?
      self.games.collect {|g| g.until = g.time + game_duration.to_i.hours; g.save}
    end
  end

  def model_after(season_id)
    return if season_id == nil
    model = Season.find(season_id)
    # Create teams
    model.teams.each do |team|
      new_team = Team.new(:name => team.name, :color => team.color, :season => self)
      new_team.save
    end
    # Calculate time difference between games
    time_diff = self.start_date.to_time + model.games[0].time.strftime("%H").to_i.hours - model.games[0].time
    # Create games
    model.games.each do |game|
      begin
        game_type = GameType.find_by_name("Season") # Copy season games only
        if game.game_type == game_type
          home_team = Team.where(:color => game.home_team.color, :season_id => self.id).first
          away_team = Team.where(:color => game.away_team.color, :season_id => self.id).first
        else
          home_team = nil
          away_team = nil
        end
      rescue
        # There may be games with no teams assigned yet
        home_team = nil
        away_team = nil
      end
      new_game = Game.new()
      new_game.season_id = self.id
      new_game.home_team = home_team
      new_game.away_team = away_team
      new_game.field_id = game.field_id
      new_game.time = game.time + time_diff
      new_game.until = game.until + time_diff
      new_game.game_type_id = game.game_type_id
      new_game.save
    end
  end
end
