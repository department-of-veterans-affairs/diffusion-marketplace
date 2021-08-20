class CreateCategoryUsage < ActiveRecord::Migration[5.2]
  def change
    create_table :category_usage do |t|
      t.belongs_to :category, foreign_key: true
      t.timestamps
    end
  end
end