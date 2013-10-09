class CreatePhotos < ActiveRecord::Migration
  def up
    create_table :photos do |t|
      t.integer :team_id
      t.string :file_name
      t.text :caption
      t.boolean :active, default: true

      t.timestamps
    end

    Team.where("file_name is not null").each do |team|
      photo = Photo.new(team: team, file_name: team.file_name, caption: team.photo_caption)
      photo.save
    end
    remove_column :teams, :file_name
    remove_column :teams, :photo_caption
  end

  def down
    add_column :teams, :file_name, :string
    add_column :teams, :photo_caption, :text
    drop_table :photos
  end
end
