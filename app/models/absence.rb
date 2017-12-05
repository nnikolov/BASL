class Absence < ActiveRecord::Base
  belongs_to :player

  def <=> (other)
    "#{game_date} #{player.name}" <=> "#{other.game_date} #{other.player.name}"
  end
end
