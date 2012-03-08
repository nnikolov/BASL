class Standing < ActiveRecord::Base
  belongs_to :team

  def self.season(params)
    game_type = GameType.find_by_name("Season")
    order = "points desc, goal_diff desc, goals_for desc, goals_against, wins desc, ties desc, losses"
    conditions = ["season_id = ? and game_type_id = ? and cached = TRUE", params[:season_id], game_type.id]
    standings = self.find(:all, :conditions => conditions, :order => order)
    if standings.size == 0
      teams = Team.find(:all, :conditions => ["season_id = ?", params[:season_id]])
      teams.each do |team|
        standing = self.new
        standing.season_id = params[:season_id]
        standing.team_id = team.id
        standing.rank = team.season_rank
        standing.points = team.points(game_type)
        standing.goal_diff = team.goal_diff(game_type)
        standing.goals_for = team.goals_for(game_type)
        standing.goals_against = team.goals_against(game_type)
        standing.wins = team.wins(game_type)
        standing.ties = team.ties(game_type)
        standing.losses = team.losses(game_type)
        standing.game_type_id = game_type.id
        standing.cached = true
        standing.save
      end
      standings = self.find(:all, :conditions => conditions, :order => order)
    end
    standings
  end

  def self.playoff(params)
    game_type = GameType.find_by_name("Playoff")
    order = "pool, points desc, rank, goals_against"
    conditions = ["season_id = ? and game_type_id = ? and cached = TRUE", params[:season_id], game_type.id]
    standings = self.find(:all, :conditions => conditions, :order => order)
    if standings.size == 0
      teams = Team.find(:all, :conditions => ["season_id = ?", params[:season_id]])
      teams.each do |team|
        standing = self.new
        standing.season_id = params[:season_id]
        standing.team_id = team.id
        standing.pool = team.pool.name if team.pool.respond_to?("name")
        standing.rank = 6 # team.playoff_rank
        standing.points = team.points(game_type)
        standing.goal_diff = team.goal_diff(game_type)
        standing.goals_for = team.goals_for(game_type)
        standing.goals_against = team.goals_against(game_type)
        standing.wins = team.wins(game_type)
        standing.ties = team.ties(game_type)
        standing.losses = team.losses(game_type)
        standing.game_type_id = game_type.id
        standing.cached = true
        standing.save
      end
      standings = self.find(:all, :conditions => conditions, :order => order)
      #standings.each do |standing|
      #  standing.reload
      #  self.find(:all, :conditions => ["points = ? and rank = ?", standing.points, standing.rank]).each do |tie|
      #    if standing.team.head_to_head_wins(tie.team, game_type) > tie.team.head_to_head_wins(standing.team, game_type) 
      #      standing.rank = standing.rank - 1
      #      standing.save
      #      standing.reload
      #    end
      #    if standing.team.head_to_head_wins(tie.team, game_type) < tie.team.head_to_head_wins(standing.team, game_type) 
      #      tie.rank = tie.rank - 1
      #      tie.save
      #    end
      #  end
      #end
      #standings = self.find(:all, :conditions => conditions, :order => order)
    end
    standings
  end
end
