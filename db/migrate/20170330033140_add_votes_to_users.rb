class AddVotesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :votes, :integer, default: 1
  end
end
