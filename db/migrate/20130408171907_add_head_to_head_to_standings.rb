class AddHeadToHeadToStandings < ActiveRecord::Migration
  def change
    add_column :standings, :hth_wins, :integer
    add_column :standings, :hth_ties, :integer
    add_column :standings, :hth_losses, :integer
  end
end
