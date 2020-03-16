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

ActiveRecord::Schema.define(version: 2020_03_16_094956) do

  create_table "absences", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "player_id"
    t.date "game_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_date"], name: "index_absences_on_game_date"
    t.index ["player_id"], name: "index_absences_on_player_id"
  end

  create_table "commercial_listings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "company_name"
    t.string "player_name"
    t.string "title"
    t.string "business_type"
    t.string "telephone"
    t.string "email"
    t.string "website"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "map_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "location"
  end

  create_table "game_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "season_id"
    t.datetime "time"
    t.integer "field_id"
    t.integer "home_team_id"
    t.integer "home_team_score"
    t.integer "away_team_id"
    t.integer "away_team_score"
    t.integer "game_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "until"
  end

  create_table "news", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_bytes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "team_id"
    t.string "file_name"
    t.text "caption"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.boolean "manager"
    t.boolean "active"
    t.string "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "position"
    t.integer "number"
    t.date "birthdate"
    t.string "filename"
  end

  create_table "pools", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "player_id"
    t.integer "user_id"
    t.decimal "rank", precision: 4, scale: 2
    t.integer "votes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_rankings_on_player_id"
    t.index ["user_id"], name: "index_rankings_on_user_id"
  end

  create_table "registration_landing_pages", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrations", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "season_standings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "season_id"
    t.integer "team_id"
    t.integer "points"
    t.integer "goal_diff"
    t.integer "goals_for"
    t.integer "goals_against"
    t.integer "wins"
    t.integer "ties"
    t.integer "losses"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "start_date"
    t.boolean "current"
    t.boolean "active"
  end

  create_table "standings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "season_id"
    t.integer "team_id"
    t.string "pool"
    t.integer "rank"
    t.integer "points"
    t.integer "goal_diff"
    t.integer "goals_for"
    t.integer "goals_against"
    t.integer "wins"
    t.integer "ties"
    t.integer "losses"
    t.integer "game_type_id"
    t.boolean "cached"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "hth_wins"
    t.integer "hth_ties"
    t.integer "hth_losses"
  end

  create_table "teams", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "pool_id"
    t.string "content_type"
    t.binary "file_data", limit: 16777215
    t.boolean "active", default: true
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password"
    t.string "email"
    t.boolean "admin"
    t.boolean "active"
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "votes", default: 1
    t.boolean "website", default: false
  end

end
