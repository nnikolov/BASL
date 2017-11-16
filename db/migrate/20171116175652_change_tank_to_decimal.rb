class ChangeTankToDecimal < ActiveRecord::Migration[5.1]
  def change
    change_column :rankings, :rank, :decimal, precision: 4, scale: 2
  end
end
