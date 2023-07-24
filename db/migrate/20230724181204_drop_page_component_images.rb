class DropPageComponentImages < ActiveRecord::Migration[6.0]
  def up
    drop_table :page_component_images
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
