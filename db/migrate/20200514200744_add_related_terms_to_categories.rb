class AddRelatedTermsToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :related_terms, :string, array:true, default: []
  end
end
