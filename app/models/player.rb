class Player < ActiveRecord::Base
  validates :name, :presence => true
  validates :team_id, :presence => true
  validates :number, :numericality => { :only_integer => true }, :allow_nil => true
  belongs_to :team
  has_one :season, :through => :team
  has_many :rankings
  has_many :absences

  attr_accessor :names

  def absent(game)
    !Absence.where(player_id: id, game_date: game.time.to_date).first.nil?
  end

  def current_ranking
    rank_sum = 0
    rank_votes = 0
    rankings.each do |r|
      rank_sum = rank_sum + r.rank * r.votes
      rank_votes = rank_votes + r.votes
    end
    return 0 if rank_votes <= 0
    (rank_sum.to_f / rank_votes).round(2)
  end

  def total_votes
    #Ranking.sum(:votes, conditions: {player_id: id})
    rank_votes = 0
    rankings.each do |r|
      rank_votes = rank_votes + r.votes
    end
    rank_votes
  end

  def ranking(user_id)
    r = Ranking.where(player_id: id, user_id: user_id).first
    return r unless r.nil?
    Ranking.new
  end

  def multi_save
    if self.names.split(/\r?\n/).size == 0
      return self.save
    end
    self.names.split(/\r?\n/).each do |line|
      values = line.split(",")
      Player.new(name: "#{values[0]} #{values[1]}", birthdate: values[2], position: values[3], active: self.active, note: self.note, team_id: self.team_id, manager: false).save
    end
  end

  def <=>(other)
    self.name <=> other.name
  end
end
