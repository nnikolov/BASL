class ChangeRankToF < ActiveRecord::Migration[5.1]
  def change
    change_column :rankings, :rank, :decimal
  end
end
