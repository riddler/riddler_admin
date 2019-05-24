class CreateRiddlerAdminActions < ActiveRecord::Migration[5.2]
  def change
    create_table :ra_actions, id: :string do |t|
      t.timestamps
      t.string :type, null: false
      t.string :transition_type, null: false
      t.string :name, null: false
      t.references :actionable, polymorphic: true, index: true, type: :string
      t.integer :position
      t.jsonb :options
      t.string :include_predicate
    end
  end
end
