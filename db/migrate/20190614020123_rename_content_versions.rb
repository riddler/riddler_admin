class RenameContentVersions < ActiveRecord::Migration[5.2]
  def change
    rename_table :ra_content_definitions, :ra_content_versions
    rename_column :ra_slugs, :content_definition_id, :content_version_id
  end
end
