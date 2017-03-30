class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :player_id
      t.integer :user_id
      t.integer :rank
      t.integer :votes

      t.index :player_id
      t.index :user_id

      t.timestamps null: false
    end
  end
end
