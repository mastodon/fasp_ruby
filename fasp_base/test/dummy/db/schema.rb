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

ActiveRecord::Schema[8.0].define(version: 2025_02_12_113456) do
  create_table "fasp_base_servers", force: :cascade do |t|
    t.string "base_url", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fasp_private_key_pem", null: false
    t.string "fasp_remote_id"
    t.string "public_key_pem"
    t.string "registration_completion_uri"
    t.json "enabled_capabilities"
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

  add_foreign_key "fasp_base_servers", "fasp_base_users", column: "user_id"
end
