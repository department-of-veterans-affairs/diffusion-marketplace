class CategoryUsage < ApplicationRecord
  belongs_to :category


  def self.store_chosen_categories(s_query, chosen_categories)
    match_search_query_to_categories s_query unless s_query.blank?
    if !chosen_categories.blank?
      cat_ids = get_chosen_category_ids(chosen_categories)
      cat_ids.each do |cat_id|
        CategoryUsage.create(category_id: cat_id)
      end
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

  def self.match_search_query_to_categories(s_query)
    s_query = s_query.downcase
    cats = []
    cat_ids = []
    categories = Category.all.where(is_other: false)
    categories.each do |cat_rec|
      cats << cat_rec.name.downcase!
      cat_ids << cat_rec.id
    end
    id_ctr = 0
    if !cats.blank?
      cats.each do |internal_cat|
        if internal_cat != nil
          if s_query.include?(internal_cat)  || s_query == internal_cat  #internal_cat.include?(s_query)
            CategoryUsage.create(category_id: cat_ids[id_ctr])
          end
        end
        id_ctr += 1
      end
    end
  end
end