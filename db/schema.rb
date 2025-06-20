# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_05_17_191057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilties", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "day"
    t.index ["user_id"], name: "index_availabilties_on_user_id"
  end

  create_table "cares", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "day"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_cares_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.integer "last_day"
    t.text "rules"
    t.text "warning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "infos"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_cares", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "care_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_id"], name: "index_user_cares_on_care_id"
    t.index ["user_id"], name: "index_user_cares_on_user_id"
  end

  create_table "user_maneuvers", force: :cascade do |t|
    t.integer "year"
    t.integer "number"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_maneuvers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.boolean "COD_1", default: false, null: false
    t.boolean "CATE", default: false, null: false
    t.boolean "CE_INC", default: false, null: false
    t.boolean "EQ_INC", default: false, null: false
    t.boolean "EQ_SAP", default: false, null: false
    t.boolean "STG", default: false, null: false
    t.boolean "validator", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.boolean "CA1E", default: false, null: false
    t.datetime "deleted_at"
    t.boolean "deactivated", default: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "availabilties", "users"
  add_foreign_key "cares", "users", on_delete: :nullify
  add_foreign_key "user_cares", "cares"
  add_foreign_key "user_cares", "users"
  add_foreign_key "user_maneuvers", "users"
  add_foreign_key "users", "teams"
end
