class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.belongs_to :page_group, foreign_key: true
      t.string :title
      t.string :description
      t.string :slug

      t.timestamps
    end
  end
end
