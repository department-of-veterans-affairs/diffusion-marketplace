module CategoriesHelper


  def get_top_six_categories
    #get top 6 from ahoy.events table - name: 'Selected category'




    # sql = "select cu.category_id, c.name, count(*) from category_usages cu join categories c on cu.category_id=c.id where cu.created_at >= (CURRENT_DATE - 90) group by cu.category_id, c.name order by count desc limit(6)"
    # ActiveRecord::Base.connection.execute(sql)
  end

  def update_category_usages
    s_query = params["query"]
    cat_rec = Category.where("name ILIKE ?", s_query.downcase).first
    return if cat_rec.blank?
    cat_id = cat_rec.id
    last_ahoy_event = AhoyEvent.where(name: 'Category selected').last(1)
    if last_ahoy_event.blank?
      store_chosen_categories(s_query, nil) unless s_query.blank?
    else
      event_tm = last_ahoy_event[0].time
      ev_user_id = last_ahoy_event[0].user_id
      last_ev_cat_id = last_ahoy_event[0].properties["category_id"]
      same_cat_id = cat_id == last_ev_cat_id
      same_visit = (DateTime.now.to_time.utc - event_tm) <= 2
      same_user = current_user.id == ev_user_id
      if !same_cat_id || !same_visit || !same_user
        store_chosen_categories(s_query, nil) unless s_query.blank?
      end
    end
  end

  def store_chosen_categories(s_query, chosen_categories)
    match_search_query_to_categories s_query
    if chosen_categories.present?
      chosen_categories.each do |chosen_cat|
        cat_rec = Category.find_by(name: chosen_cat)
        ahoy.track('Category selected', {category_id: cat_rec.id }) unless cat_rec.blank?
      end
    end
  end

  def match_search_query_to_categories(s_query)
    s_query = s_query.downcase
    cats = []
    cat_ids = []
    categories = Category.not_other
    categories.each do |cat_rec|
      cats << cat_rec.name.downcase!
      cat_ids << cat_rec.id
    end
    id_ctr = 0
    if cats.present?
      cats.each do |internal_cat|
        if internal_cat.present?
          if s_query.include?(internal_cat)  || s_query == internal_cat
            ahoy.track('Category selected', {category_id: cat_ids[id_ctr]})
          end
        end
        id_ctr += 1
      end
    end
  end


end
