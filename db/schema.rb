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

ActiveRecord::Schema.define(version: 2018_03_26_235452) do

  create_table "map_contents", force: :cascade do |t|
    t.string "country_code"
    t.text "comment"
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id", "country_code"], name: "index_map_contents_on_map_id_and_country_code"
    t.index ["map_id"], name: "index_map_contents_on_map_id"
  end

  create_table "maps", force: :cascade do |t|
    t.string "title"
    t.boolean "privacy_public", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "projection", default: "geoAirocean"
    t.text "blurb"
    t.boolean "example_map", default: false
    t.index ["user_id", "updated_at"], name: "index_maps_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_maps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
