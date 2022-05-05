class CategoriesController < ApplicationController
  include CategoriesHelper

  def update_category_usage
    query_val = params["query"]
    chosen_categories = params["chosenCategories"]
    cat_id = params["catId"]
    category = Category.find_by(id: cat_id)
    # check to make sure the "catId" param is present AND a category with an id that matches the params["catId"] exists before creating a 'Category selected' Ahoy event
    if cat_id.present? && category.present?
      ahoy.track('Category selected', {category_id: cat_id.to_i})
    else
      store_chosen_categories(query_val, chosen_categories)
    end
  end
end