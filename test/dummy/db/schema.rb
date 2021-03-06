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

ActiveRecord::Schema.define(version: 2019_06_14_020123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ra_actions", id: :string, force: :cascade do |t|
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
    t.index ["actionable_type", "actionable_id"], name: "index_ra_actions_on_actionable_type_and_actionable_id"
  end

  create_table "ra_content_versions", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "publish_request_id"
    t.string "content_type"
    t.string "content_id"
    t.integer "version", null: false
    t.integer "definition_schema_version", null: false
    t.jsonb "definition", null: false
    t.index ["content_type", "content_id"], name: "index_ra_content_versions_on_content_type_and_content_id"
    t.index ["id"], name: "index_ra_content_versions_on_id"
    t.index ["publish_request_id"], name: "index_ra_content_versions_on_publish_request_id"
  end

  create_table "ra_elements", id: :string, force: :cascade do |t|
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
    t.index ["container_type", "container_id"], name: "index_ra_elements_on_container_type_and_container_id"
    t.index ["id"], name: "index_ra_elements_on_id"
  end

  create_table "ra_emails", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "emailable_type"
    t.string "emailable_id"
    t.integer "position"
    t.string "title", null: false
    t.string "name", null: false
    t.string "subject"
    t.string "body"
    t.string "css"
    t.string "include_predicate"
    t.boolean "preview_enabled", default: false
    t.index ["emailable_type", "emailable_id"], name: "index_ra_emails_on_emailable_type_and_emailable_id"
    t.index ["id"], name: "index_ra_emails_on_id"
  end

  create_table "ra_preview_contexts", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "params"
    t.string "headers"
    t.string "yaml"
    t.string "encrypted_yaml"
    t.index ["id"], name: "index_ra_preview_contexts_on_id"
    t.index ["title"], name: "index_ra_preview_contexts_on_title", unique: true
  end

  create_table "ra_publish_requests", id: :string, force: :cascade do |t|
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
    t.index ["content_type", "content_id"], name: "index_ra_publish_requests_on_content_type_and_content_id"
    t.index ["id"], name: "index_ra_publish_requests_on_id"
  end

  create_table "ra_slugs", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "status", default: "live", null: false
    t.string "content_version_id", null: false
    t.string "interaction_identity"
    t.string "target_predicate"
    t.index ["content_version_id"], name: "index_ra_slugs_on_content_version_id"
    t.index ["id"], name: "index_ra_slugs_on_id"
    t.index ["name"], name: "index_ra_slugs_on_name", unique: true
  end

  create_table "ra_steps", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "title"
    t.string "name", null: false
    t.string "stepable_type"
    t.string "stepable_id"
    t.integer "position"
    t.string "include_predicate"
    t.boolean "preview_enabled", default: false
    t.index ["id"], name: "index_ra_steps_on_id"
    t.index ["stepable_type", "stepable_id"], name: "index_ra_steps_on_stepable_type_and_stepable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
