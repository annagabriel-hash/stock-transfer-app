# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_03_104713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buys", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "user_id", null: false
    t.float "price", null: false
    t.integer "shares", null: false
    t.integer "status", default: 0, null: false
    t.integer "order_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_buys_on_stock_id"
    t.index ["user_id"], name: "index_buys_on_user_id"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "stocks_id", null: false
    t.date "period", null: false
    t.float "open"
    t.float "high"
    t.float "low"
    t.float "close"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stocks_id"], name: "index_prices_on_stocks_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "sells", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "user_id", null: false
    t.float "price", null: false
    t.integer "shares", null: false
    t.integer "status", default: 0, null: false
    t.integer "order_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_sells_on_stock_id"
    t.index ["user_id"], name: "index_sells_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "ticker", null: false
    t.string "name"
    t.float "market_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "buy_id", null: false
    t.bigint "sell_id"
    t.float "price", null: false
    t.integer "shares", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buy_id"], name: "index_trades_on_buy_id"
    t.index ["sell_id"], name: "index_trades_on_sell_id"
    t.index ["stock_id"], name: "index_trades_on_stock_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "user_stocks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "stock_id", null: false
    t.boolean "watch", default: false
    t.integer "shares", default: 0
    t.index ["stock_id"], name: "index_user_stocks_on_stock_id"
    t.index ["user_id"], name: "index_user_stocks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.float "balance", default: 100000.0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status"], name: "index_users_on_status"
  end

  add_foreign_key "buys", "stocks"
  add_foreign_key "buys", "users"
  add_foreign_key "prices", "stocks", column: "stocks_id"
  add_foreign_key "sells", "stocks"
  add_foreign_key "sells", "users"
  add_foreign_key "trades", "buys"
  add_foreign_key "trades", "sells"
  add_foreign_key "trades", "stocks"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_stocks", "stocks"
  add_foreign_key "user_stocks", "users"
end
