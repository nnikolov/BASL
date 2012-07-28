# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120728043138) do

  create_table "commercial_listings", :force => true do |t|
    t.string   "company_name"
    t.string   "player_name"
    t.string   "title"
    t.string   "business_type"
    t.string   "telephone"
    t.string   "email"
    t.string   "website"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "map_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

  create_table "game_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "season_id"
    t.datetime "time"
    t.integer  "field_id"
    t.integer  "home_team_id"
    t.integer  "home_team_score"
    t.integer  "away_team_id"
    t.integer  "away_team_score"
    t.integer  "game_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_bytes", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "team_id"
    t.boolean  "manager"
    t.boolean  "active"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "season_standings", :force => true do |t|
    t.integer  "season_id"
    t.integer  "team_id"
    t.integer  "points"
    t.integer  "goal_diff"
    t.integer  "goals_for"
    t.integer  "goals_against"
    t.integer  "wins"
    t.integer  "ties"
    t.integer  "losses"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.boolean  "current"
  end

  create_table "standings", :force => true do |t|
    t.integer  "season_id"
    t.integer  "team_id"
    t.string   "pool"
    t.integer  "rank"
    t.integer  "points"
    t.integer  "goal_diff"
    t.integer  "goals_for"
    t.integer  "goals_against"
    t.integer  "wins"
    t.integer  "ties"
    t.integer  "losses"
    t.integer  "game_type_id"
    t.boolean  "cached"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pool_id"
    t.string   "file_name"
    t.string   "content_type"
    t.binary   "file_data",    :limit => 16777215
    t.boolean  "active",                           :default => true
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.boolean  "admin"
    t.boolean  "active"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
