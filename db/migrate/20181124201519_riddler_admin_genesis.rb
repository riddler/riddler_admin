class RiddlerAdminGenesis < ActiveRecord::Migration[5.2]
  def change
    create_table :ra_steps, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :type, null: false
      t.string :title
      t.string :name, null: false
      t.references :stepable, polymorphic: true, index: true, type: :string
      t.integer :position
      t.string :include_predicate
      t.boolean :preview_enabled, default: false
    end

    create_table :ra_elements, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :type, null: false
      t.string :name, null: false
      t.references :container, polymorphic: true, index: true, type: :string
      t.integer :position
      t.string :text
      t.string :url
      t.string :include_predicate
    end

    create_table :ra_preview_contexts, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :title, null: false
      t.string :params
      t.string :headers
      t.string :yaml
      t.string :encrypted_yaml
    end

    add_index :ra_preview_contexts, :title, unique: true

    create_table :ra_publish_requests, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.timestamp :approved_at
      t.timestamp :published_at
      t.string :title, null: false
      t.string :description
      t.string :status, default: "active", null: false
      t.references :content, polymorphic: true, index: true, type: :string
    end

    create_table :ra_content_definitions, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.integer :schema_version, null: false
      t.references :publish_request, type: :string
      t.references :content, polymorphic: true, index: true, type: :string
      t.integer :version, null: false
      t.jsonb :definition, null: false
    end

    create_table :ra_slugs, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :name, null: false
      t.string :status, default: "live", null: false
      t.references :content_definition, type: :string, null: false
      t.string :interaction_identity
    end
    add_index :ra_slugs, :name, unique: true
  end
end
