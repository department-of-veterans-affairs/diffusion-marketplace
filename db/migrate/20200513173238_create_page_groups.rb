class CreatePageGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :page_groups do |t|
      t.string :name
      t.string :description
      t.string :slug, unique:true
      t.timestamps
    end
    add_index :page_groups, :slug, unique: true
  end
end
