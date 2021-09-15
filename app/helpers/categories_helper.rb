module CategoriesHelper


  def get_most_popular_categories
    #get top 6 from ahoy.events table - name: 'Selected category'
    recs_category_selected = AhoyEvent.where(name: "Category selected")
    recs = recs_category_selected.where("time > ?", Time.now-90.days)
    rec_array = []
    popular_categories = []
    recs.each do |rec|
      rec_array << rec.properties["category_id"]
    end
    categories_count = Hash.new(0)
    rec_array.each { |rec| categories_count[rec] +=1 }
    pop_cats = categories_count.sort_by { |rec,number| number}.last(20).reverse
    pop_cats.each do |pop_cat|
      popular_categories << Category.find_by_id(pop_cat[0]).name
    end
    popular_categories
  end

  def update_category_usages
    s_query = ActiveRecord::Base.sanitize_sql_like(params["query"])
    cat_rec = Category.where("name ILIKE ?", s_query.downcase).not_other.first
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
      same_user = current_user.present? ? current_user.id == ev_user_id : ev_user_id.blank?
      debugger
      if !(same_cat_id && same_visit && same_user)
        store_chosen_categories(s_query, nil) unless s_query.blank?
      end
    end
  end

  def store_chosen_categories(s_query, chosen_categories)
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
    if chosen_categories.present?
      chosen_categories.each do |chosen_cat|
        cat_rec = Category.find_by(name: chosen_cat)
        ahoy.track('Category selected', {category_id: cat_rec.id }) unless cat_rec.blank?
      end
    end
  end
end
