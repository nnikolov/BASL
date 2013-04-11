class Team < ActiveRecord::Base
  belongs_to :season
  belongs_to :pool
  validates :name, :presence => true , :uniqueness => { :scope => :season_id}
  validates :color, :presence => true , :uniqueness => { :scope => :season_id}
  validates :season_id, :presence => true
  has_many :players, :order => :name, :conditions => ["players.active = true"]

  #def <=>(other)
  #  game_type = GameType.where(:name => 'Season').first
  #  r = self.points(game_type) <=> other.points(game_type)
  #  return r if r != 0 
  #  r = self.head_to_head_wins(other, game_type) <=> other.head_to_head_wins(self, game_type)
  #  return r if r != 0 
  #  r = self.head_to_head_wins(other, game_type) <=> other.head_to_head_wins(self, game_type)
  #  return self.name <=> other.name
  #end

  #def to_s
  #  display
  #end

  def display
    return color if name.blank?
    return name if color.blank?
    "#{name} (#{color})"
  end

  def games
    Game.find(:all, :conditions => ["home_team_id = ? or away_team_id = ?", id, id])
  end

  def after_save
    # clear stanings cache
    Standing.delete_all(["season_id = ?", self.season_id])
  end

  def points(game_type)
    if game_type.name == "Season"
      wins(game_type).to_i * 3 + ties(game_type).to_i
    else
      wins(game_type).to_i * 6 + ties(game_type).to_i * 3 + playoff_shutouts + playoff_goals_carrying_points
    end
  end

  def wins(game_type, *args)
    if args.size > 0
      home_wins = Game.where("home_team_id = ? and home_team_score > away_team_score and game_type_id = ? and away_team_id in (?)", self, game_type, args).size
      away_wins = Game.where("away_team_id = ? and away_team_score > home_team_score and game_type_id = ? and home_team_id in (?)", self, game_type, args).size
    else
      home_wins = Game.where("home_team_id = ? and home_team_score > away_team_score and game_type_id = ?", self, game_type).size
      away_wins = Game.where("away_team_id = ? and away_team_score > home_team_score and game_type_id = ?", self, game_type).size
    end
    home_wins + away_wins
  end

  def ties(game_type, *args)
    if args.size > 0
      home_ties = Game.where("home_team_id = ? and home_team_score = away_team_score and game_type_id = ? and away_team_id in (?)", self.id, game_type.id, args).size
      away_ties = Game.where("away_team_id = ? and away_team_score = home_team_score and game_type_id = ? and home_team_id in (?)", self.id, game_type.id, args).size
    else
      home_ties = Game.where("home_team_id = ? and home_team_score = away_team_score and game_type_id = ?", self.id, game_type.id).size
      away_ties = Game.where("away_team_id = ? and away_team_score = home_team_score and game_type_id = ?", self.id, game_type.id).size
    end
    home_ties + away_ties
  end

  def losses(game_type, *args)
    if args.size > 0
      home_losses = Game.where("home_team_id = ? and home_team_score < away_team_score and game_type_id = ? and away_team_id in (?)", self, game_type, args).size
      away_losses = Game.where("away_team_id = ? and away_team_score < home_team_score and game_type_id = ? and home_team_id in (?)", self, game_type, args).size
    else
      home_losses = Game.where("home_team_id = ? and home_team_score < away_team_score and game_type_id = ?", self, game_type).size
      away_losses = Game.where("away_team_id = ? and away_team_score < home_team_score and game_type_id = ?", self, game_type).size
    end
    home_losses + away_losses
  end

  def goals_for(game_type)
    game_type.name == "Playoff" ? playoff_goals_for(game_type) : season_goals_for(game_type)
  end

  def season_goals_for(game_type)
    home_goals = Game.where("home_team_id = ? and game_type_id = ?", self.id, game_type.id).select("sum(home_team_score) as total").first
    away_goals = Game.where("away_team_id = ? and game_type_id = ?", self.id, game_type.id).select("sum(away_team_score) as total").first
    home_goals.total.to_i + away_goals.total.to_i
  end

  def playoff_goals_for(game_type)
    # D. Most goals scored (maximum of (4) per match).
    home_goals = Game.where("home_team_id = ? and game_type_id = ? and home_team_score < 5", self.id, game_type.id).select("sum(home_team_score) as total").first
    away_goals = Game.where("away_team_id = ? and game_type_id = ? and away_team_score < 5", self.id, game_type.id).select("sum(away_team_score) as total").first
    hg_over_4 = Game.where("home_team_id = ? and game_type_id = ? and home_team_score > 4", self.id, game_type.id).count
    ag_over_4 = Game.where("away_team_id = ? and game_type_id = ? and away_team_score > 4", self.id, game_type.id).count
    home_goals.total.to_i + away_goals.total.to_i + hg_over_4 * 4 + ag_over_4 * 4
  end

  def goals_against(game_type)
    game_type.name == "Playoff" ? playoff_goals_against(game_type) : season_goals_against(game_type)
  end

  def season_goals_against(game_type)
    home_goals = Game.where("home_team_id = ? and game_type_id = ?", self.id, game_type.id).select("sum(away_team_score) as total").first
    away_goals = Game.where("away_team_id = ? and game_type_id = ?", self.id, game_type.id).select("sum(home_team_score) as total").first
    home_goals.total.to_i + away_goals.total.to_i
  end

  def playoff_goals_against(game_type)
    # C	Largest goal differential (max. of plus or minus (4) per match).
    home_goals = Game.where("home_team_id = ? and game_type_id = ? and away_team_score < 5", self.id, game_type.id).select("sum(away_team_score) as total").first
    away_goals = Game.where("away_team_id = ? and game_type_id = ? and home_team_score < 5", self.id, game_type.id).select("sum(home_team_score) as total").first
    hg_over_4 = Game.where("home_team_id = ? and game_type_id = ? and away_team_score > 4", self.id, game_type.id).count
    ag_over_4 = Game.where("away_team_id = ? and game_type_id = ? and home_team_score > 4", self.id, game_type.id).count
    home_goals.total.to_i + away_goals.total.to_i + hg_over_4 * 4 + ag_over_4 * 4
  end

  def goal_diff(game_type)
    goals_for(game_type) - goals_against(game_type)
  end

  def playoff_shutouts
    home_shutouts = Game.find(:all, 
      :conditions => ["home_team_id = ? and home_team_score > away_team_score and away_team_score = 0 and game_type_id = 2", self.id]).size
    away_shutouts = Game.find(:all, 
      :conditions => ["away_team_id = ? and away_team_score > home_team_score and home_team_score = 0 and game_type_id = 2", self.id]).size
    home_shutouts + away_shutouts
  end

  def playoff_goals_carrying_points
    home_goals_upto_max = Game.find(:all, :select => "sum(home_team_score) as total", 
               :conditions => ["home_team_id = ? and home_team_score < 4 and game_type_id = 2", self.id])
    away_goals_upto_max = Game.find(:all, :select => "sum(away_team_score) as total",
               :conditions => ["away_team_id = ? and away_team_score < 4 and game_type_id = 2", self.id])
    home_games_above_max_goals = Game.find(:all, :conditions => ["home_team_id = ? and home_team_score > 3 and game_type_id = 2", self.id]).size
    away_games_above_max_goals = Game.find(:all, :conditions => ["away_team_id = ? and away_team_score > 3 and game_type_id = 2", self.id]).size
    home_goals_upto_max[0].total.to_i + away_goals_upto_max[0].total.to_i + home_games_above_max_goals * 3 + away_games_above_max_goals * 3
  end

  #def season_rank
  #  game_type = GameType.find_by_name("Season")
  #  teams = Team.find(:all, :conditions => ["season_id = ? and id != ?", self.season_id, self.id])
  #  rank = teams.size + 1
  #  teams.each do |team|
  #    rank = rank - 1 if team.points(game_type) < self.points(game_type)
  #    rank = rank - rank_goal_diff(team, game_type) if team.points(game_type) == self.points(game_type)
  #  end
  #  rank
  #end

  #def rank_goal_diff(team, game_type)
  #  self_goal_diff = self.goal_diff(game_type)
  #  team_goal_diff = team.goal_diff(game_type)
  #  if team_goal_diff == self_goal_diff
  #    rank_goals_for(team, game_type)
  #  else
  #    team_goal_diff < self_goal_diff ? 1 : 0
  #  end
  #end

  #def rank_goals_for(team, game_type)
  #  self_goals_for = self.goals_for(game_type)
  #  team_goals_for = team.goals_for(game_type)
  #  if team_goals_for == self_goals_for
  #    rank_wins(team, game_type)
  #  else
  #    team_goals_for < self_goals_for ? 1 : 0
  #  end
  #end

  #def rank_wins(team, game_type)
  #  self_wins = self.wins(game_type)
  #  team_wins = team.wins(game_type)
  #  if team_wins == self_wins
  #    rank_ties(team, game_type)
  #  else
  #    team_wins < self_wins ? 1 : 0
  #  end
  #end

  #def rank_ties(team, game_type)
  #  self_ties = self.ties(game_type)
  #  team_ties = team.ties(game_type)
  #  #if team_ties == self_ties
  #  #  rank_head_to_head_wins(team, game_type)
  #  #else
  #    team_ties > self_ties ? 0 : 1
  #  #end
  #end

  #def rank_head_to_head_wins(team, game_type)
  #  wins = head_to_head_wins(team, game_type)
  #  losses = head_to_head_losses(team, game_type)
  #  games_played = head_to_head_games_played(team, game_type)
  #  if games_played == 0 or wins == losses
  #    rank_head_to_head_goal_difference(team, game_type)
  #  else
  #    result = losses < wins ? 1 : 0
  #    RAILS_DEFAULT_LOGGER.error("\n\n\nAAA\n#{self.name} wins: #{wins} losses: #{losses} #{team.name} result = #{result}\n")
  #    result
  #  end
  #end

  #def rank_head_to_head_goal_difference(team, game_type)
  #  goals_for = head_to_head_goals_for(team, game_type)
  #  goals_against = team.head_to_head_goals_for(self, game_type)
  #  result = goals_against < goals_for ? 1 : 0
  #  RAILS_DEFAULT_LOGGER.error("\n\n\nBBB\n#{self.name} #{goals_for} #{team.name} #{goals_against} result = #{result}\n")
  #  result
  #end

  #def head_to_head_goals_for(team, game_type)
  #  home_goals = Game.find(:all, :select => "sum(home_team_score) as total", 
  #    :conditions => ["home_team_id = ? and away_team_id = ? and game_type_id = ?", self.id, team.id, game_type.id])
  #  away_goals = Game.find(:all, :select => "sum(away_team_score) as total", 
  #    :conditions => ["away_team_id = ? and home_team_id = ? and game_type_id = ?", self.id, team.id, game_type.id])
  #  home_goals[0].total.to_i + away_goals[0].total.to_i
  #end

  #def playoff_rank
  #  game_type = GameType.find_by_name("Playoff")
  #  teams = Team.find(:all, :conditions => ["season_id = ? and id != ?", self.season_id, self.id])
  #  rank = teams.size + 1
  #  teams.each do |team|
  #    rank = rank - 1 if team.points(game_type) < self.points(game_type)
  #    rank = rank - rank_playoff_head_to_head_wins(team) if team.points(game_type) == self.points(game_type)
  #  end
  #  rank
  #end

  #def rank_playoff_head_to_head_wins(team)
  #  game_type = GameType.find_by_name("Playoff")
  #  wins = head_to_head_wins(team, game_type)
  #  games_played = head_to_head_games_played(team, game_type)
  #  losses = games_played - wins
  #  if games_played == 0 or wins == losses
  #    rank_playoff_goals_against(team)
  #  else
  #    wins < losses ? 1 : 0
  #  end
  #end

  #def head_to_head_wins(team, game_type)
  #  home_wins = Game.find(:all, 
  #     :conditions => ["home_team_id = ? and away_team_id = ? and home_team_score > away_team_score and game_type_id = ?", self.id, team.id, game_type.id]).size
  #  away_wins = Game.find(:all, 
  #     :conditions => ["away_team_id = ? and home_team_id = ? and away_team_score > home_team_score and game_type_id = ?", self.id, team.id, game_type.id]).size
  #  home_wins + away_wins
  #end

  #def head_to_head_ties(team, game_type)
  #  home_ties = Game.find(:all, 
  #     :conditions => ["home_team_id = ? and away_team_id = ? and home_team_score = away_team_score and game_type_id = ?", self.id, team.id, game_type.id]).size
  #  away_ties = Game.find(:all, 
  #     :conditions => ["away_team_id = ? and home_team_id = ? and away_team_score = home_team_score and game_type_id = ?", self.id, team.id, game_type.id]).size
  #  home_ties + away_ties
  #end

  #def head_to_head_losses(team, game_type)
  #  home_losses = Game.find(:all, 
  #     :conditions => ["home_team_id = ? and away_team_id = ? and home_team_score < away_team_score and game_type_id = ?", self.id, team.id, game_type.id]).size
  #  away_losses = Game.find(:all, 
  #     :conditions => ["away_team_id = ? and home_team_id = ? and away_team_score < home_team_score and game_type_id = ?", self.id, team.id, game_type.id]).size
  #  home_losses + away_losses
  #end

  #def head_to_head_games_played(team, game_type)
  #  Game.find(:all,
  #     :conditions => ["(away_team_id = ? or away_team_id = ?) and (home_team_id = ? or home_team_id = ?) and game_type_id = ? 
  #     and home_team_score is not null and away_team_score is not null", self.id, team.id, self.id, team.id, game_type.id]).size
  #end

  #def rank_playoff_goals_against(team)
  #  game_type = GameType.find_by_name("Playoff")
  #  if team.goals_against(game_type) == self.goals_against(game_type)
  #    0
  #  else
  #    self.goals_against(game_type) < team.goals_against(game_type) ? 1 : 0
  #  end
  #end
  
  def calendar(event_url)
    cal = RiCal.Calendar do |cal|
      cal.add_x_property 'X-WR-CALNAME', "#{display} games"
      cal.add_x_property 'X-WR-CALDESC', "BA Soccer League games schedule for #{display}"
      games.each do |game|
        cal.event do |event|
          event.summary     = "#{game.home_team.display} vs. #{game.away_team.display} @ #{game.field.name}"
          event.description = "#{game.home_team.display} vs. #{game.away_team.display} @ #{game.field.name}"
          event.dtstart     = game.time
          event.dtend       = game.until || game.time + 1.hour
          event.location    = game.field.location.to_s
          event.url         = event_url
        end
      end
    end
    cal
  end
end
