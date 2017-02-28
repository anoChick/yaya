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

ActiveRecord::Schema.define(version: 20170228115838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_states", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "key",          limit: 255
    t.text     "value"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name",       limit: 48
    t.string   "user_id"
    t.text     "icon_url"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "codes", force: :cascade do |t|
    t.string   "name",         limit: 48
    t.integer  "user_id"
    t.integer  "character_id"
    t.boolean  "waiting"
    t.boolean  "private"
    t.text     "url"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "slack_id",        limit: 48
    t.integer  "my_character_id"
    t.string   "name",            limit: 48
    t.string   "handle_name",     limit: 48
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "webhooks", force: :cascade do |t|
    t.string   "name",         limit: 48
    t.string   "uid",          limit: 255
    t.string   "channel",      limit: 255
    t.integer  "character_id"
    t.integer  "user_id"
    t.boolean  "waiting"
    t.boolean  "private"
    t.text     "url"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "widgets", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
