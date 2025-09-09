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

ActiveRecord::Schema.define(version: 2025_09_01_141957) do

  create_table "admins", force: :cascade do |t|
    t.string "user_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "user_name", default: "", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "company"
    t.string "post_title"
    t.string "representative_name"
    t.string "contact_name"
    t.string "tel"
    t.string "address"
    t.string "url"
    t.string "message"
    t.string "recruit_url"
    t.string "visa"
    t.string "business"
    t.string "genre"
    t.string "salary"
    t.string "work_time"
    t.string "day_off"
    t.string "work_contents"
    t.string "number"
    t.string "house_agents"
    t.string "house_support"
    t.string "remarks"
    t.string "plan"
    t.string "total_price"
    t.string "agree"
    t.string "contract_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "status"
    t.string "next"
    t.string "body"
    t.integer "user_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_comments_on_client_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "tel"
    t.string "email"
    t.string "messages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivers", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "title", null: false
    t.string "image"
    t.text "body"
    t.integer "count", default: 0
    t.datetime "reservation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_delivers_on_client_id"
  end

  create_table "estimates", force: :cascade do |t|
    t.string "name"
    t.string "tel"
    t.string "email"
    t.string "postnumber"
    t.string "address"
    t.string "people"
    t.date "check_in_date"
    t.date "check_out_date"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "choice"
    t.string "company"
    t.string "url"
  end

  create_table "months", force: :cascade do |t|
    t.string "name"
    t.string "tel"
    t.string "email"
    t.string "postnumber"
    t.string "address"
    t.string "people"
    t.date "check_in_date"
    t.date "check_out_date"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name", default: "", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "age"
    t.string "experience"
    t.string "voice_data"
    t.string "year"
    t.string "commodity"
    t.string "hope"
    t.string "period"
    t.string "pc"
    t.string "start"
    t.string "tel"
    t.string "agree_1"
    t.string "agree_2"
    t.string "emergency_name"
    t.string "emergency_relationship"
    t.string "emergency_tel"
    t.string "identification"
    t.string "bank"
    t.string "branch"
    t.string "bank_number"
    t.string "bank_name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weeks", force: :cascade do |t|
    t.string "name"
    t.string "tel"
    t.string "email"
    t.string "postnumber"
    t.string "address"
    t.string "people"
    t.date "check_in_date"
    t.date "check_out_date"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
