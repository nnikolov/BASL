class Team < ActiveRecord::Base
  attr_accessor :photo_caption, :file_name
  belongs_to :season
  belongs_to :pool
  validates :name, :presence => true , :uniqueness => { :scope => :season_id}
  validates :color, :presence => true , :uniqueness => { :scope => :season_id}
  validates :season_id, :presence => true
  has_many :photos
  has_many :players, -> { where(active: true).order('position, name')}
  #has_many :nplayers, :class_name => "Player", :order => "number", :conditions => ["players.active = true"]
  has_many :nplayers, -> { where(active: true).order('number')}, class_name: 'Player'
  #has_one :manager, :class_name => "Player", :conditions => ["players.manager = true"]
  has_one :manager, -> { where(manager: true)}, class_name: 'Player'
  has_one :keeper, -> { where(position: "GK")}, class_name: 'Player'

  def season_standing
    season_standings.rank
    rescue
      0
  end

  def season_points
    season_standings.points
    rescue
      0
  end

  def season_goal_diff
    season_standings.goal_diff
    rescue
      0
  end

  def season_standings
    Standing.where(team_id: id, game_type_id: GameType.where(name: 'Season')).first
    rescue
      nil
  end

  def manager_name
    manager.name
    rescue
      'No manager'
  end

  def keeper_name
    keeper.name
    rescue
      'No keeper'
  end

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
    home_shutouts = Game.where(["home_team_id = ? and home_team_score > away_team_score and away_team_score = 0 and game_type_id = 2", self.id]).size
    away_shutouts = Game.where(["away_team_id = ? and away_team_score > home_team_score and home_team_score = 0 and game_type_id = 2", self.id]).size
    home_shutouts + away_shutouts
  end

  def playoff_goals_carrying_points
    #home_goals_upto_max = Game.find(:all, :select => "sum(home_team_score) as total", 
    #           :conditions => ["home_team_id = ? and home_team_score < 4 and game_type_id = 2", self.id])
    home_goals_upto_max = Game.where(["home_team_id = ? and home_team_score < 4 and game_type_id = 2", self.id]).sum(:home_team_score)
    #away_goals_upto_max = Game.find(:all, :select => "sum(away_team_score) as total",
    #           :conditions => ["away_team_id = ? and away_team_score < 4 and game_type_id = 2", self.id])
    away_goals_upto_max = Game.where(["away_team_id = ? and away_team_score < 4 and game_type_id = 2", self.id]).sum(:away_team_score)
    home_games_above_max_goals = Game.where(["home_team_id = ? and home_team_score > 3 and game_type_id = 2", self.id]).size
    away_games_above_max_goals = Game.where(["away_team_id = ? and away_team_score > 3 and game_type_id = 2", self.id]).size
    #home_goals_upto_max[0].total.to_i + away_goals_upto_max[0].total.to_i + home_games_above_max_goals * 3 + away_games_above_max_goals * 3
    home_goals_upto_max + away_goals_upto_max + home_games_above_max_goals * 3 + away_games_above_max_goals * 3
  end

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

  #def update_attributes(attributes)
  #  super
  #end
end
