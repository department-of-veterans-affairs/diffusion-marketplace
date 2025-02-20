module CategoriesHelper
  def get_categories_by_popularity(only_communities=false)
    time_limit = Time.now - 90.days
    Rails.cache.fetch("categories_with_popularity_#{only_communities ? 'communities' : 'non_communities'}", expires_in: 24.hours) do
      query = Category.joins(
                'LEFT JOIN ahoy_events ' \
                'ON categories.id = CAST(ahoy_events.properties ->> \'category_id\' AS INTEGER) ' \
                'AND ahoy_events.name = \'Category selected\' ' \
                'AND ahoy_events.time > \'' + time_limit.to_fs(:db) + '\'')
              .joins('LEFT JOIN categories as parent_categories ON categories.parent_category_id = parent_categories.id')
              .where.not(parent_category_id: nil)

      if only_communities
        query = query.where(parent_categories: { name: 'Communities' })
      else
        query = query.where.not(parent_categories: { name: 'Communities' })
      end

      query.group('categories.id')
          .order('COUNT(ahoy_events.id) DESC, categories.name')
          .pluck('categories.id', 'categories.name')
          .map { |id, name| { id: id, name: name } }
    end
  end

  def update_category_usages
    s_query = ActiveRecord::Base.sanitize_sql_like(params["query"])
    cat_rec = Category.where("name ILIKE ?", s_query.downcase).first
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
    category_ids_and_names = Category.pluck(:id, :name).map { |cat| { id: cat.first, name: cat.last.downcase } }
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

  def category_id_for_category(category)
    parent_category_name = category.parent_category.name.downcase
    category_id = category.id ? category.id : "#{category.name.split(' ').first.downcase}-#{parent_category_name}"
  end

  def hyphenated_category_name_for(category)
    category.name.split(' ').join('-').downcase
  end

  def category_css_class(category_name, parent_category_name)
    category_name.include?('All') ? hyphenated_category_name_for(category_name) : parent_category_name
  end

  def is_category_checked?(category, innovation)
    parent_category = category.parent_category
    has_all_categories = parent_category.sub_categories.count == CategoryPractice.where(innovable: innovation).joins(:category).where(categories: { parent_category_id: parent_category.id }).count
    is_pr_cat = innovation.categories.include?(category)
    is_pr_cat || has_all_categories
  end
end
