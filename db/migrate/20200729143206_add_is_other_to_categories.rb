class AddIsOtherToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :is_other, :boolean, default: false
  end
end
