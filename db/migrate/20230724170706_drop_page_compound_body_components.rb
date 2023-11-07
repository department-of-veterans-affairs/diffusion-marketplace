class DropPageCompoundBodyComponents < ActiveRecord::Migration[6.0]
   def up
    drop_table :page_compound_body_components
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
