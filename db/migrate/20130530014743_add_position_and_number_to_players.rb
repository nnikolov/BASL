class AddPositionAndNumberToPlayers < ActiveRecord::Migration
  def up
    add_column :players, :position, :string
    add_column :players, :number, :integer

    Player.where("note is not null").each do |player|
      if player.note == "FWD" or player.note == "MID"
        player.position = "A#{player.note}"
      else
        player.position = player.note
      end 
      player.note = nil
      player.save
    end
  end

  def down
    remove_column :players, :position
    remove_column :players, :number
  end
end
