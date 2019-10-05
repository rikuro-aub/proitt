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

ActiveRecord::Schema.define(version: 2019_10_05_015949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tags", force: :cascade do |t|
    t.string "tag", null: false
    t.boolean "active_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "videos", force: :cascade do |t|
    t.string "video_id", null: false
    t.bigint "tag_id"
    t.text "description"
    t.text "thumbnail_url"
    t.bigint "view_count"
    t.integer "like_count"
    t.integer "dislike_count"
    t.integer "favorite_count"
    t.boolean "active_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.index ["tag_id"], name: "index_videos_on_tag_id"
  end

end
