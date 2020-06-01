class MigrateComponentsToUuid < ActiveRecord::Migration[5.2]
  def up
    enable_extension 'pgcrypto'

    add_column :page_header_components, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :page_header2_components, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :page_paragraph_components, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :page_subpage_hyperlink_components, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :page_practice_list_components, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }

    add_column :page_components, :component_uuid, :uuid

    execute <<-SQL
      UPDATE page_components SET component_uuid = page_header_components.uuid
      FROM page_header_components WHERE page_components.component_id = page_header_components.id;

      UPDATE page_components SET component_uuid = page_header2_components.uuid
      FROM page_header2_components WHERE page_components.component_id = page_header2_components.id;

      UPDATE page_components SET component_uuid = page_paragraph_components.uuid
      FROM page_paragraph_components WHERE page_components.component_id = page_paragraph_components.id;

      UPDATE page_components SET component_uuid = page_subpage_hyperlink_components.uuid
      FROM page_subpage_hyperlink_components WHERE page_components.component_id = page_subpage_hyperlink_components.id;

      UPDATE page_components SET component_uuid = page_practice_list_components.uuid
      FROM page_practice_list_components WHERE page_components.component_id = page_practice_list_components.id;
    SQL

    change_column_null :page_components, :component_uuid, false

    remove_column :page_components, :component_id
    rename_column :page_components, :component_uuid, :component_id

    add_index :page_components, :component_id

    remove_column :page_header_components, :id
    rename_column :page_header_components, :uuid, :id
    remove_column :page_header2_components, :id
    rename_column :page_header2_components, :uuid, :id
    remove_column :page_paragraph_components, :id
    rename_column :page_paragraph_components, :uuid, :id
    remove_column :page_subpage_hyperlink_components, :id
    rename_column :page_subpage_hyperlink_components, :uuid, :id
    remove_column :page_practice_list_components, :id
    rename_column :page_practice_list_components, :uuid, :id

    execute "ALTER TABLE page_header_components ADD PRIMARY KEY (id);"
    execute "ALTER TABLE page_header2_components ADD PRIMARY KEY (id);"
    execute "ALTER TABLE page_paragraph_components ADD PRIMARY KEY (id);"
    execute "ALTER TABLE page_subpage_hyperlink_components ADD PRIMARY KEY (id);"
    execute "ALTER TABLE page_practice_list_components ADD PRIMARY KEY (id);"

    add_index :page_components, :position
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
