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

ActiveRecord::Schema.define(version: 20170823120711) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: :cascade do |t|
    t.string "short_url"
    t.text "original_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visitors_count", default: 0
    t.index ["short_url"], name: "index_links_on_short_url", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.string "ip"
    t.string "browser"
    t.string "browser_version"
    t.string "os"
    t.string "country"
    t.string "city"
    t.bigint "link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_visitors_on_link_id"
  end

end
