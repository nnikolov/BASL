class AddPhotoCaptionToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :photo_caption, :text
  end
end
