module CategoriesHelper
  def get_category_names_by_popularity
    time_limit = Time.now - 90.days
    Rails.cache.fetch('categories_with_popularity', expires_in: 24.hours) do
      # returns only category names that can be found in the filters on the /search page,
      # raw SQL allows for joining category selection events to be used for ordering,
      # left joins allows categories with no selection events to be returned
      Category.where(is_other: false)
              .joins(
                'LEFT JOIN ahoy_events ' \
                'ON categories.id = CAST(ahoy_events.properties ->> \'category_id\' AS INTEGER) ' \
                'AND ahoy_events.name = \'Category selected\' ' \
                'AND ahoy_events.time > \'' + time_limit.to_s(:db) + '\''
              )
              .joins(:parent_category)
              .where.not(parent_category: nil)
              .group('categories.id')
              .order('COUNT(ahoy_events.id) DESC, categories.name')
              .pluck('categories.name')
    end
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
    category_ids_and_names = Category.not_other.pluck(:id, :name).map { |cat| { id: cat.first, name: cat.last.downcase } }
    matching_category = category_ids_and_names.find { |cat| s_query.strip.downcase === cat[:name] }

    if matching_category.present?
      ahoy.track('Category selected', { category_id: matching_category[:id] })
    end

    if chosen_categories.present?
      chosen_categories.each do |chosen_cat|
        cat_rec = Category.find_by(name: chosen_cat)
        if cat_rec.present?
          ahoy.track('Category selected', { category_id: cat_rec.id })
        end
      end
    end
  end
end
