# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170330033140) do

  create_table "absences", force: :cascade do |t|
    t.integer  "player_id",  limit: 4
    t.date     "game_date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "absences", ["game_date"], name: "index_absences_on_game_date", using: :btree
  add_index "absences", ["player_id"], name: "index_absences_on_player_id", using: :btree

  create_table "commercial_listings", force: :cascade do |t|
    t.string   "company_name",  limit: 255
    t.string   "player_name",   limit: 255
    t.string   "title",         limit: 255
    t.string   "business_type", limit: 255
    t.string   "telephone",     limit: 255
    t.string   "email",         limit: 255
    t.string   "website",       limit: 255
    t.text     "description",   limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.string   "map_url",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location",   limit: 255
  end

  create_table "game_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "season_id",       limit: 4
    t.datetime "time"
    t.integer  "field_id",        limit: 4
    t.integer  "home_team_id",    limit: 4
    t.integer  "home_team_score", limit: 4
    t.integer  "away_team_id",    limit: 4
    t.integer  "away_team_score", limit: 4
    t.integer  "game_type_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "until"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_bytes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "team_id",    limit: 4
    t.string   "file_name",  limit: 255
    t.text     "caption",    limit: 65535
    t.boolean  "active",                   default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "team_id",    limit: 4
    t.boolean  "manager"
    t.boolean  "active"
    t.string   "note",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position",   limit: 255
    t.integer  "number",     limit: 4
  end

  create_table "pools", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", force: :cascade do |t|
    t.integer  "player_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "rank",       limit: 4
    t.integer  "votes",      limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rankings", ["player_id"], name: "index_rankings_on_player_id", using: :btree
  add_index "rankings", ["user_id"], name: "index_rankings_on_user_id", using: :btree

  create_table "rules", force: :cascade do |t|
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "season_standings", force: :cascade do |t|
    t.integer  "season_id",     limit: 4
    t.integer  "team_id",       limit: 4
    t.integer  "points",        limit: 4
    t.integer  "goal_diff",     limit: 4
    t.integer  "goals_for",     limit: 4
    t.integer  "goals_against", limit: 4
    t.integer  "wins",          limit: 4
    t.integer  "ties",          limit: 4
    t.integer  "losses",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.boolean  "current"
    t.boolean  "active"
  end

  create_table "standings", force: :cascade do |t|
    t.integer  "season_id",     limit: 4
    t.integer  "team_id",       limit: 4
    t.string   "pool",          limit: 255
    t.integer  "rank",          limit: 4
    t.integer  "points",        limit: 4
    t.integer  "goal_diff",     limit: 4
    t.integer  "goals_for",     limit: 4
    t.integer  "goals_against", limit: 4
    t.integer  "wins",          limit: 4
    t.integer  "ties",          limit: 4
    t.integer  "losses",        limit: 4
    t.integer  "game_type_id",  limit: 4
    t.boolean  "cached"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hth_wins",      limit: 4
    t.integer  "hth_ties",      limit: 4
    t.integer  "hth_losses",    limit: 4
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "color",        limit: 255
    t.integer  "season_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pool_id",      limit: 4
    t.string   "content_type", limit: 255
    t.binary   "file_data",    limit: 16777215
    t.boolean  "active",                        default: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "username",      limit: 255
    t.string   "password",      limit: 255
    t.string   "email",         limit: 255
    t.boolean  "admin"
    t.boolean  "active"
    t.integer  "created_by_id", limit: 4
    t.integer  "updated_by_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes",         limit: 4,   default: 1
  end

end
