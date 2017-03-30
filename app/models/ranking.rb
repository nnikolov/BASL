class Ranking < ActiveRecord::Base

  belongs_to :user
  belongs_to :player

  before_save :check_votes

  private

  def check_votes
    if votes > user.votes
      self.votes = user.votes
    end
    if rank > 10
      self.rank = 10
    end
  end
end
