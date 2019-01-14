class CreateRiddlerAdminGenesis < ActiveRecord::Migration[5.2]
  def change
    create_table :riddler_steps, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :type, null: false
      t.string :title
      t.string :name, null: false
      t.boolean :preview_enabled, default: false
    end

    create_table :riddler_elements, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :type, null: false
      t.string :name
      t.references :container, polymorphic: true, index: true, type: :string
      t.integer :position
      t.string :text
      t.string :href
      t.string :include_predicate
    end

    create_table :riddler_preview_contexts, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :title
      t.string :params
      t.string :headers
      t.jsonb :data
    end

    add_index :riddler_preview_contexts, :title, unique: true

    create_table :riddler_publish_requests, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.timestamp :approved_at
      t.timestamp :published_at
      t.string :title
      t.string :description
      t.string :status, default: "active"
      t.references :content, polymorphic: true, index: true, type: :string
      t.jsonb :content_definition
    end
  end
end
