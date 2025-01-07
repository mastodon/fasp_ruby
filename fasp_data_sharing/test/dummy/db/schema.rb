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

ActiveRecord::Schema[8.0].define(version: 2025_01_03_141700) do
  create_table "fasp_base_servers", force: :cascade do |t|
    t.string "base_url", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fasp_private_key_pem", null: false
    t.string "fasp_remote_id"
    t.string "public_key_pem"
    t.string "registration_completion_uri"
    t.index [ "base_url" ], name: "index_fasp_base_servers_on_base_url", unique: true
    t.index [ "user_id" ], name: "index_fasp_base_servers_on_user_id"
  end

  create_table "fasp_base_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "email" ], name: "index_fasp_base_users_on_email", unique: true
  end

  create_table "fasp_data_sharing_actors", force: :cascade do |t|
    t.text "private_key_pem", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fasp_data_sharing_backfill_requests", force: :cascade do |t|
    t.integer "fasp_base_server_id", null: false
    t.string "remote_id", null: false
    t.string "category", null: false
    t.integer "max_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fulfilled", default: false, null: false
    t.index [ "fasp_base_server_id" ], name: "idx_on_fasp_base_server_id_0f3fe7f51e"
  end

  create_table "fasp_data_sharing_subscriptions", force: :cascade do |t|
    t.integer "fasp_base_server_id", null: false
    t.string "remote_id", null: false
    t.string "category", null: false
    t.string "subscription_type", null: false
    t.integer "max_batch_size"
    t.integer "threshold_timeframe"
    t.integer "threshold_shares"
    t.integer "threshold_likes"
    t.integer "threshold_replies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "fasp_base_server_id" ], name: "index_fasp_data_sharing_subscriptions_on_fasp_base_server_id"
  end

  add_foreign_key "fasp_base_servers", "fasp_base_users", column: "user_id"
  add_foreign_key "fasp_data_sharing_backfill_requests", "fasp_base_servers"
  add_foreign_key "fasp_data_sharing_subscriptions", "fasp_base_servers"
end
