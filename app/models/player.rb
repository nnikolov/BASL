class Player < ActiveRecord::Base
  validates :name, :presence => true
  validates :team_id, :presence => true
  belongs_to :team
  has_one :season, :through => :team
end
