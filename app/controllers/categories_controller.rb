class CategoriesController < ApplicationController
  include CategoriesHelper

  def update_category_usage
    query_val = params["query"]
    chosen_categories = params["chosenCategories"]
    cat_id = params["catId"]
    if cat_id.present?
      ahoy.track('Category selected', {category_id: cat_id})
    else
      store_chosen_categories(query_val, chosen_categories)
    end
  end

end