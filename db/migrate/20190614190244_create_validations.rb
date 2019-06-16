class CreateValidations < ActiveRecord::Migration[5.2]
  def change
    create_table :ra_validations, id: :string do |t|
      t.timestamps
      t.string :type, null: false
      t.references :element, null: false, foreign_key: true
      t.string :message
    end
  end
end
