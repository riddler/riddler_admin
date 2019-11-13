class RiddlerAdminGenesis < ActiveRecord::Migration[5.2]
  def change
    create_table :rid_actions, id: :string do |t|
      t.timestamps
      t.string :type, null: false
      t.string :transition_type, null: false
      t.string :name, null: false
      t.references :actionable, polymorphic: true, index: true, type: :string
      t.integer :position
      t.jsonb :options
      t.string :include_predicate
    end

    create_table :rid_elements, id: :string do |t|
      t.timestamps
      t.string :type, null: false
      t.string :name, null: false
      t.references :container, polymorphic: true, index: true, type: :string
      t.integer :position
      t.string :text
      t.string :url
      t.string :include_predicate
    end

    create_table :rid_content_versions, id: :string do |t|
      t.timestamps
      t.references :publish_request, type: :string
      t.references :content, polymorphic: true, index: true, type: :string
      t.integer :version, null: false
      t.integer :definition_schema_version, null: false
      t.jsonb :definition, null: false
    end

    create_table :rid_preview_contexts, id: :string do |t|
      t.timestamps
      t.string :title, null: false
      t.string :params
      t.string :headers
      t.string :yaml
      t.string :encrypted_yaml
    end
    add_index :rid_preview_contexts, :title, unique: true

    create_table :rid_publish_requests, id: :string do |t|
      t.timestamps
      t.timestamp :approved_at
      t.string :approved_by_id
      t.string :approved_by_name
      t.timestamp :published_at
      t.string :title, null: false
      t.string :description
      t.string :status, default: "pending", null: false
      t.references :content, polymorphic: true, index: true, type: :string
    end

    create_table :rid_steps, id: :string do |t|
      t.timestamps
      t.string :type, null: false
      t.string :name, null: false
      t.string :title
      t.references :stepable, polymorphic: true, index: true, type: :string
      t.integer :position
      t.string :include_predicate
      t.boolean :preview_enabled, default: false
    end

    create_table :rid_slugs, id: :string do |t|
      t.timestamps
      t.string :name, null: false
      t.string :status, default: "live", null: false
      t.references :content_version, type: :string, null: false
      t.string :interaction_identity
      t.string :target_predicate
    end
    add_index :rid_slugs, :name, unique: true

    create_table :rid_toggles, id: :string do |t|
      t.timestamps
      t.string :type, null: false
      t.string :name, null: false
      t.string :title
      t.string :include_condition
      t.jsonb :include_condition_instructions
      t.jsonb :options
    end
    add_index :rid_toggles, :name, unique: true
  end
end
