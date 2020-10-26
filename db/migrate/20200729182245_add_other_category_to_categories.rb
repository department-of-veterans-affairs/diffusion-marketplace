class AddOtherCategoryToCategories < ActiveRecord::Migration[5.2]
  def change
    Category.create!({name: 'Other'})
  end
end
