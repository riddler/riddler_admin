class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :ra_emails, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :type, null: false
      t.references :emailable, polymorphic: true, index: true, type: :string
      t.integer :position
      t.string :title, null: false
      t.string :name, null: false
      t.string :subject, null: false
      t.string :body, null: false
      t.string :css
      t.string :include_predicate
      t.boolean :preview_enabled, default: false
    end
  end
end
