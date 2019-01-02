class CreateRiddlerAdminSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :riddler_steps, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :type, null: false
      t.string :name
    end

    create_table :riddler_elements, id: false do |t|
      t.primary_key :id, :string, index: true
      t.timestamps
      t.string :type, null: false
      t.string :name
      t.references :container, polymorphic: true, index: true, type: :string
      t.integer :position
      t.string :text
    end
  end
end