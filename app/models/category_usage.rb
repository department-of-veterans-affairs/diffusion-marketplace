class CategoryUsage < ApplicationRecord
  belongs_to :category


  def self.store_chosen_categories(s_query, chosen_categories)
    match_search_query_to_categories s_query unless s_query.blank?
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

  def self.match_search_query_to_categories(s_query)
    debugger
    s_query = s_query.downcase
    cats = []
    categories = Category.all
    categories.each do |cat_name|
      cats << cat_name.name.downcase!
    end
    debugger
    if !cats.blank?
      cats.each do |internal_cat|
        if internal_cat != nil
          if s_query.include? internal_cat
            debugger
          end
        end
      end
    end
    debugger
  end
end