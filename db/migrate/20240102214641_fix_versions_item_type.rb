class FixVersionsItemType < ActiveRecord::Migration[6.1]
  def up
    remove_column :versions, :"{:null=>false}", :string, if_exists: true

    default_item_type = 'DefaultItemType'
    Version.where(item_type: nil).update_all(item_type: default_item_type)
    change_column_null :versions, :item_type, false
    unless index_exists?(:versions, [:item_type, :item_id])
      add_index :versions, [:item_type, :item_id], name: 'index_versions_on_item_type_and_item_id'
    end
  end

  def down
    change_column_null :versions, :item_type, true
    remove_index :versions, name: 'index_versions_on_item_type_and_item_id', if_exists: true
  end
end
