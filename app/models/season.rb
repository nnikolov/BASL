class Season < ActiveRecord::Base
  has_many :teams, :order => "name"
  has_many :games, :order => "time, id"

  def before_save
    if self.current # Set all other seasons to not current
      sql = ActiveRecord::Base.connection();
      sql.execute("update seasons set current = 0")
    end
  end
end
