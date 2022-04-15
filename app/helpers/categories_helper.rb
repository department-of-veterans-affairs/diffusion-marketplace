module CategoriesHelper


  def get_most_popular_categories
    pop_cat_names = []
    categories_count = Ahoy::Event.where(name: "Category selected").where("time > ?", Time.now-90.days).pluck(:properties).map { |d| d["category_id"].to_i }.tally
    if categories_count.present?
      pop_cats = categories_count.sort_by { |rec, number| number  }.last(20).reverse
      pop_cat_ids = pop_cats.map {|row| row[0]}
      pop_cat_names = Category.where(id: pop_cat_ids).pluck(:name)
    end
    pop_cat_names
  end

  def update_category_usages
    s_query = ActiveRecord::Base.sanitize_sql_like(params["query"])
    cat_rec = Category.where("name ILIKE ?", s_query.downcase).not_other.first
    return if cat_rec.blank?
    cat_id = cat_rec.id
    last_ahoy_event = Ahoy::Event.where(name: 'Category selected').last(1)
    if last_ahoy_event.blank?
      store_chosen_categories(s_query, nil) unless s_query.blank?
    else
      event_tm = last_ahoy_event[0].time
      ev_user_id = last_ahoy_event[0].user_id
      last_ev_cat_id = last_ahoy_event[0].properties["category_id"]
      same_cat_id = cat_id == last_ev_cat_id
      same_visit = (DateTime.now.to_time.utc - event_tm) <= 2
      same_user = current_user.present? ? current_user.id == ev_user_id : ev_user_id.blank?
      if !(same_cat_id && same_visit && same_user)
        store_chosen_categories(s_query, nil) unless s_query.blank?
      end
    end
  end

  def store_chosen_categories(s_query, chosen_categories)
    s_query = s_query.downcase
    cat_names = Category.not_other.pluck(:name).map { |cat| cat.downcase }
    cat_ids = Category.not_other.pluck(:id)
    id_ctr = 0
    if cat_names.present?
      cat_names.each do |internal_cat|
        if s_query.include?(internal_cat) || s_query == internal_cat
          ahoy.track('Category selected', {category_id: cat_ids[id_ctr]})
        end
        id_ctr += 1
      end
    end
    if chosen_categories.present?
      chosen_categories.each do |chosen_cat|
        cat_rec = Category.find_by(name: chosen_cat)
        ahoy.track('Category selected', {category_id: cat_rec.id }) unless cat_rec.blank?
      end
    end
  end
end
