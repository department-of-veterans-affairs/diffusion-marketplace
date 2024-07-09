class RemoveIsOtherFromCategories < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :is_other, :boolean
  end
end
