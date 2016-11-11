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

ActiveRecord::Schema.define(version: 20161111012440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "vehicles", force: :cascade do |t|
    t.string   "plate"
    t.string   "frame"
    t.string   "engine"
    t.string   "cityname"
    t.integer  "citycode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wz_cases", force: :cascade do |t|
    t.integer  "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
    t.index ["vehicle_id"], name: "index_wz_cases_on_vehicle_id", using: :btree
  end

  create_table "wz_items", force: :cascade do |t|
    t.integer  "wz_case_id"
    t.text     "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info"], name: "index_wz_items_on_info", using: :btree
    t.index ["wz_case_id"], name: "index_wz_items_on_wz_case_id", using: :btree
  end

  create_table "wz_queries", force: :cascade do |t|
    t.text     "info"
    t.integer  "wz_case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wz_case_id"], name: "index_wz_queries_on_wz_case_id", using: :btree
  end

  add_foreign_key "wz_cases", "vehicles"
  add_foreign_key "wz_items", "wz_cases"
  add_foreign_key "wz_queries", "wz_cases"
end
