class CreateAbsences < ActiveRecord::Migration
  def change
    create_table :absences do |t|
      t.integer :player_id
      t.date :game_date

      t.timestamps null: false
    end
    add_index :absences, :player_id
    add_index :absences, :game_date
  end
end
