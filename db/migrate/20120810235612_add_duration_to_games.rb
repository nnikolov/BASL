class AddDurationToGames < ActiveRecord::Migration
  def up
    add_column :games, :until, :datetime
    Season.find(12).games.collect {|g| g.until = g.time + 2.hours; g.save}
  end
  def down
    remove_column :games, :until
  end
end
