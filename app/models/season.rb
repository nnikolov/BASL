class Season < ActiveRecord::Base
  has_many :teams
  has_many :games, :order => "time"

  def before_save
    if self.current # Set all other seasons to not current
      sql = ActiveRecord::Base.connection();
      sql.execute("update seasons set current = 0")
    end
  end
end
