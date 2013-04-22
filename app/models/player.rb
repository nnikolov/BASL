class Player < ActiveRecord::Base
  validates :name, :presence => true
  validates :team_id, :presence => true
  belongs_to :team
  has_one :season, :through => :team

  attr_accessor :names

  def multi_save
    if self.names.split(/\r?\n/).size == 0
      return self.save
    end
    self.names.split(/\r?\n/).each do |name|
      Player.new(:name => name, :active => self.active, :note => self.note, :team_id => self.team_id, :manager => false).save
    end
  end
end
