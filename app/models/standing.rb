class Standing < ActiveRecord::Base
  belongs_to :team

  #def <=>(other)
  #  # Croatia 111 2  : Italy 111 7  Italy   3496
  #  # Croatia 301    : Germany 103  Croatia 3494
  #  # Germany 111 15 : Italy 111 7  Germany 3497
  #  order = "points, hth_wins, hth_ties, hth_losses, goal_diff, goals_for, goals_agains, wins, ties, losses".split(", ")
  #  order.each do |criteria|
  #    result = season_compare(criteria, self, other)
  #    return result if result > 0 or result < 0
  #  end
  #  0
  #end

  #def season_compare(criteria, standing1, standing2)
  #  gt = GameType.find_by_name("Season")
  #  case criteria
  #  when "hth_wins"
  #    standing1.team.head_to_head_wins(standing2.team, gt) <=> standing2.team.head_to_head_wins(standing1.team, gt)
  #  when "hth_ties"
  #    standing1.team.head_to_head_ties(standing2.team, gt) <=> standing2.team.head_to_head_ties(standing1.team, gt)
  #  when "hth_losses"
  #    standing2.team.head_to_head_losses(standing1.team, gt) <=> standing1.team.head_to_head_losses(standing2.team, gt)
  #  when "losses"
  #    standing2.losses <=> standing1.losses
  #  else
  #    standing1.send(criteria) <=> standing2.send(criteria)
  #  end
  #end

  def self.create_standings(season_id, game_type)
    # calculate points, wins, ties and so on and store in db
    standings = []
    teams = Team.where :season_id => season_id, :active => true
    teams.each do |team|
      standing = self.new
      standing.season_id = season_id
      standing.team_id = team.id
      #standing.rank = 0 #team.season_rank
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
  end

  def self.resolve_ties(season_id, game_type)
    # Find the teams that are tied in points and populate head to head
    standings = self.where(:season_id => season_id, :game_type_id => game_type.id, :cached => true)
    standings.each do |standing|
      if game_type.name == "Playoff"
        ties = self.where("season_id = ? and points = ? and id <> ? and game_type_id = ? and pool = ?", season_id, standing.points, standing.id, game_type.id, standing.pool).all
      else
        ties = self.where("season_id = ? and points = ? and id <> ? and game_type_id = ?", season_id, standing.points, standing.id, game_type.id).all
      end
      ties.each do |tie|
        standing.hth_wins = standing.hth_wins.to_i + standing.team.wins(game_type, tie.team)
        standing.hth_ties = standing.hth_ties.to_i + standing.team.ties(game_type, tie.team)
        standing.hth_losses = standing.hth_losses.to_i + standing.team.losses(game_type, tie.team)
        standing.save
      end
    end
  end

  def self.rank(season_id, game_type)
    game_type.name == "Playoff" ? playoff_rank(season_id, game_type) : season_rank(season_id, game_type)
  end

  def self.season_rank(season_id, game_type)
    # order standings and populate rank
    self.where(:season_id => season_id, :game_type_id => game_type.id, :cached => true).order("points desc, hth_wins desc, hth_ties desc, hth_losses, goal_diff desc, goals_for desc, goals_against, wins desc, ties desc, losses").each_with_index do |standing, i|
      standing.rank = i + 1
      standing.save
    end
  end

  def self.playoff_rank(season_id, game_type)
    pools = self.where(:season_id => season_id, :game_type_id => game_type.id, :cached => true).group(:pool).having("count(*) > 1").all
    pools.each do |pool|
      self.where(:season_id => season_id, :game_type_id => game_type.id, :cached => true, :pool => pool.pool).order("points desc, hth_wins desc, hth_ties desc, hth_losses, goals_against, goal_diff desc, goals_for desc").each_with_index do |standing, i|
        standing.rank = i + 1
        standing.save
      end
    end
  end

  def self.season(params)
    game_type = GameType.find_by_name("Season")
    where = {:season_id => params[:season_id], :game_type_id => game_type.id, :cached => true}
    standings = self.where(where).order("rank")
    # if standings have not been calculated yet
    if standings.size == 0
      create_standings(params[:season_id], game_type)
      resolve_ties(params[:season_id], game_type)
      rank(params[:season_id], game_type)
      # retrieve teams based on rank
      standings = self.where(where).order("rank")
    end
    standings
  end

  def self.playoff(params)
    game_type = GameType.find_by_name("Playoff")
    order = "pool, points desc, rank, goals_against"
    conditions = ["season_id = ? and game_type_id = ? and cached = TRUE", params[:season_id], game_type.id]
    #standings = self.find(:all, :conditions => conditions, :order => order)
    standings = self.where(conditions).order(order).all
    if standings.size == 0
      teams = Team.where :season_id => params[:season_id], :active => true
      teams.each do |team|
        standing = self.new
        standing.season_id = params[:season_id]
        standing.team_id = team.id
        standing.pool = team.pool.name if team.pool.respond_to?("name")
        #standing.rank = 6 # team.playoff_rank
        standing.points = team.points(game_type)
        standing.goal_diff = team.goal_diff(game_type)
        standing.goals_for = team.goals_for(game_type)
        standing.goals_against = team.season_goals_against(game_type)
        standing.wins = team.wins(game_type)
        standing.ties = team.ties(game_type)
        standing.losses = team.losses(game_type)
        standing.game_type_id = game_type.id
        standing.cached = true
        standing.save
      end
      resolve_ties(params[:season_id], game_type)
      rank(params[:season_id], game_type)
      #standings = self.find(:all, :conditions => conditions, :order => order)
      standings = self.where(conditions).order(order)
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
