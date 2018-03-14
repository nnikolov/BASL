class Absence < ActiveRecord::Base
  belongs_to :player

  def self.create_multiple(absences)
    absences[:player_id].each do |player_id|
      unless player_id.blank?
        Absence.create(player_id: player_id, game_date: "#{absences['game_date(1i)']}-#{absences['game_date(2i)']}-#{absences['game_date(3i)']}")
      end
    end
    true
  end

  def <=> (other)
    "#{game_date} #{player.name}" <=> "#{other.game_date} #{other.player.name}"
  end
end
