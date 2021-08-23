class CategoryUsage < ApplicationRecord
  belongs_to :category


  def self.store_chosen_categories(s_query, chosen_categories)
    cat_ids = get_chosen_category_ids(chosen_categories)
    cat_ids.each do |cat_id|
      CategoryUsage.create(category_id: cat_id)
    end

  end

  def self.get_chosen_category_ids(chosen_categories)
    cat_ids = []
    chosen_categories.each do |chosen_cat|
      cat_rec = Category.where(:name => chosen_cat).first
      cat_ids << cat_rec.id unless cat_rec.blank?
    end
    cat_ids
  end
end