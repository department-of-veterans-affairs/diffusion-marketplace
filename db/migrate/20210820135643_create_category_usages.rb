class CreateCategoryUsages < ActiveRecord::Migration[5.2]
  def change
    create_table :category_usages do |t|
      t.belongs_to :category, foreign_key: true
      t.string :key
      t.timestamps
    end
  end
end