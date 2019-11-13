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

ActiveRecord::Schema.define(version: 2019_01_26_153702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rid_actions", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "transition_type", null: false
    t.string "name", null: false
    t.string "actionable_type"
    t.string "actionable_id"
    t.integer "position"
    t.jsonb "options"
    t.string "include_predicate"
    t.index ["actionable_type", "actionable_id"], name: "index_rid_actions_on_actionable_type_and_actionable_id"
  end

  create_table "rid_content_versions", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "publish_request_id"
    t.string "content_type"
    t.string "content_id"
    t.integer "version", null: false
    t.integer "definition_schema_version", null: false
    t.jsonb "definition", null: false
    t.index ["content_type", "content_id"], name: "index_rid_content_versions_on_content_type_and_content_id"
    t.index ["publish_request_id"], name: "index_rid_content_versions_on_publish_request_id"
  end

  create_table "rid_elements", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "name", null: false
    t.string "container_type"
    t.string "container_id"
    t.integer "position"
    t.string "text"
    t.string "url"
    t.string "include_predicate"
    t.index ["container_type", "container_id"], name: "index_rid_elements_on_container_type_and_container_id"
  end

  create_table "rid_feature_flags", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "name", null: false
    t.string "title"
    t.string "include_condition"
    t.jsonb "include_condition_instructions"
    t.jsonb "options"
    t.index ["name"], name: "index_rid_feature_flags_on_name", unique: true
  end

  create_table "rid_preview_contexts", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "params"
    t.string "headers"
    t.string "yaml"
    t.string "encrypted_yaml"
    t.index ["title"], name: "index_rid_preview_contexts_on_title", unique: true
  end

  create_table "rid_publish_requests", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "approved_at"
    t.string "approved_by_id"
    t.string "approved_by_name"
    t.datetime "published_at"
    t.string "title", null: false
    t.string "description"
    t.string "status", default: "pending", null: false
    t.string "content_type"
    t.string "content_id"
    t.index ["content_type", "content_id"], name: "index_rid_publish_requests_on_content_type_and_content_id"
  end

  create_table "rid_slugs", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "status", default: "live", null: false
    t.string "content_version_id", null: false
    t.string "interaction_identity"
    t.string "target_predicate"
    t.index ["content_version_id"], name: "index_rid_slugs_on_content_version_id"
    t.index ["name"], name: "index_rid_slugs_on_name", unique: true
  end

  create_table "rid_steps", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "name", null: false
    t.string "title"
    t.string "stepable_type"
    t.string "stepable_id"
    t.integer "position"
    t.string "include_predicate"
    t.boolean "preview_enabled", default: false
    t.index ["stepable_type", "stepable_id"], name: "index_rid_steps_on_stepable_type_and_stepable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
