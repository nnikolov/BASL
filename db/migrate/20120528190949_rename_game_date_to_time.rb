class RenameGameDateToTime < ActiveRecord::Migration
  def up
    rename_column :games, :game_date, :time
  end

  def down
    rename_column :games, :time, :game_date
  end
end
