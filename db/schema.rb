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

ActiveRecord::Schema.define(version: 20140305121903) do

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company_type"
    t.string   "ref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", force: true do |t|
    t.string   "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tradegecko_creds", force: true do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "expires_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tradegecko_creds", ["user_id"], name: "index_tradegecko_creds_on_user_id", using: :btree

  create_table "trademe_creds", force: true do |t|
    t.string   "token"
    t.string   "token_secret"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trademe_creds", ["user_id"], name: "index_trademe_creds_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
