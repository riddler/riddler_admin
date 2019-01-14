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

ActiveRecord::Schema.define(version: 2018_11_24_201519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "riddler_elements", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "name"
    t.string "container_type"
    t.string "container_id"
    t.integer "position"
    t.string "text"
    t.string "href"
    t.string "include_predicate"
    t.index ["container_type", "container_id"], name: "index_riddler_elements_on_container_type_and_container_id"
    t.index ["id"], name: "index_riddler_elements_on_id"
  end

  create_table "riddler_preview_contexts", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "params"
    t.string "headers"
    t.jsonb "data"
    t.index ["id"], name: "index_riddler_preview_contexts_on_id"
    t.index ["title"], name: "index_riddler_preview_contexts_on_title", unique: true
  end

  create_table "riddler_publish_requests", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "approved_at"
    t.datetime "published_at"
    t.string "title"
    t.string "description"
    t.string "status", default: "active"
    t.string "content_type"
    t.string "content_id"
    t.jsonb "content_definition"
    t.index ["content_type", "content_id"], name: "index_riddler_publish_requests_on_content_type_and_content_id"
    t.index ["id"], name: "index_riddler_publish_requests_on_id"
  end

  create_table "riddler_steps", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "title"
    t.string "name", null: false
    t.boolean "preview_enabled", default: false
    t.index ["id"], name: "index_riddler_steps_on_id"
  end

end
