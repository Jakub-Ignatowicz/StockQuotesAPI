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

ActiveRecord::Schema[7.1].define(version: 2024_04_02_220929) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exchanges", force: :cascade do |t|
    t.string "name", limit: 256, null: false
    t.string "mic", limit: 4, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", default: 0
    t.index ["mic"], name: "index_exchanges_on_mic", unique: true
  end

  create_table "instruments", force: :cascade do |t|
    t.string "ticker", limit: 20, null: false
    t.string "name", limit: 256, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exchange_id", null: false
    t.integer "lock_version", default: 0
    t.index ["exchange_id"], name: "index_instruments_on_exchange_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.datetime "time", precision: nil, null: false
    t.decimal "open", precision: 11, scale: 4, null: false
    t.decimal "close", precision: 11, scale: 4, null: false
    t.decimal "high", precision: 11, scale: 4, null: false
    t.decimal "low", precision: 11, scale: 4, null: false
    t.integer "volume", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "instrument_id", null: false
    t.integer "lock_version", default: 0
    t.index ["instrument_id"], name: "index_quotes_on_instrument_id"
  end

  add_foreign_key "instruments", "exchanges"
  add_foreign_key "quotes", "instruments"
end
