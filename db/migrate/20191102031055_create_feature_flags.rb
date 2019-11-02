class CreateFeatureFlags < ActiveRecord::Migration[5.2]
  def change
    create_table :ra_feature_flags, id: :string do |t|
      t.timestamps
      t.string :name, null: false
      t.boolean :enabled
    end
  end
end
