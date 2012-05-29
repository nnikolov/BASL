class RenameSeasonStartDateToStartDate < ActiveRecord::Migration
  def up
    rename_column :seasons, :season_start_date, :start_date
  end

  def down
    rename_column :seasons, :start_date, :season_start_date
  end
end
