module PracticeUtils
  def practices_json(practices)
    practices_array = []

    practices.each do |practice|
      practice_hash = JSON.parse(practice.to_json) # convert to hash
      practice_hash['image'] = practice.main_display_image.present? ? practice.main_display_image_s3_presigned_url(:thumb) : ''
      if practice.date_initiated
        practice_hash['date_initiated'] = practice.date_initiated.strftime("%B %Y")
      else
        practice_hash['date_initiated'] = '(start date unknown)'
      end

      if practice.categories&.size > 0
        practice_hash['category_names'] = []
        categories = practice.categories.not_other.not_none
        categories.each do |category|
          practice_hash['category_names'].push category.name

          unless category.related_terms.empty?
            practice_hash['category_names'].concat(category.related_terms)
          end
        end
      end

      # display initiating facility
      practice_hash['retired'] = practice.retired
      practice_hash['initiating_facility_name'] = helpers.origin_display(practice)
      practice_hash['initiating_facility'] = practice.initiating_facility
      origin_facilities = practice.practice_origin_facilities.collect{ |pof| pof.va_facility.station_number }
      practice_hash['origin_facilities'] = origin_facilities
      practice_hash['user_favorited'] = current_user.favorite_practice_ids.include?(practice.id) if current_user.present?

      # get diffusion history facilities
      adoptions = practice.diffusion_histories.includes([:va_facility]).collect{ |dh| dh.va_facility.station_number }
      practice_hash['adoption_facilities'] = adoptions
      practice_hash['adoption_count'] = adoptions.size

      # get practice partners
      practice_partner_names = practice.practice_partners.pluck(:name)
      practice_hash['practice_partner_names'] = practice_partner_names

      practices_array.push practice_hash
    end

    practices_array.to_json.html_safe
  end

  def get_categories_by_practices(practices, practice_categories)
    practices.each do |p|
      categories = p.categories.not_other.not_none
      categories.each do |c|
        practice_categories << c unless practice_categories.include?(c)
      end
    end
    practice_categories.sort_by! { |pc| pc.name.downcase }
  end

  def practice_leader_board(practice, count, created_at = DateTime.now())
    {practice_name: practice.name, practice_slug: practice.slug, count: count, created_at: created_at}
  end

  def fetch_page_view_for_practice_count(practice_id, duration = "30")
    page_view_leaders = []
    sql = "select name, properties, count(properties) as count from ahoy_events where name = 'Practice show' and time >= $1 group by name, properties"
    records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{Time.now - duration.to_i.days}"]])
    # records_array = prepare_sql.execute(sql)
    #recs = records_array.values
    records_array.each do |rec|
      if practice_id == JSON.parse(rec["properties"])["practice_id"]
        practice = practice_leader_board(Practice.find(practice_id), rec["count"])
        page_view_leaders << practice
      end
    end
    if page_view_leaders.empty?
      return 0
    else
      page_view_leaders[0][:count]
    end
  end

  def fetch_page_views_for_practice(practice_id, duration = "30")
    page_views = []
    sql = "select name, properties, time from ahoy_events where name = 'Practice show' and properties = $1"
    param1 = "{\"practice_id\": #{practice_id}}"
    if duration == "30"
      sql += " and time >= $2"
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1], [nil, "#{Time.now - duration.to_i.days}"]])
    else
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1]])
    end
    records_array.each do |rec|
      if practice_id == JSON.parse(rec["properties"])["practice_id"]
        practice = practice_leader_board(Practice.find(practice_id), 0, rec["time"].to_date)
        page_views << practice
      end
    end
    page_views
  end

  def fetch_unique_visitors_by_practice_count(practice_id, duration = "30")
    sql = "select distinct user_id from ahoy_events where name = 'Practice show' and properties = $1"
    param1 = "{\"practice_id\": #{practice_id}}"
    if duration == "30"
      sql += " and time >= $2"
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1], [nil, "#{Time.now - duration.to_i.days}"]])
    else
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1]])
    end
    records_array.count
  end

  def fetch_unique_visitors_by_practice(practice_id, duration = "30")
    sql = "select user_id, time from ahoy_events where name = 'Practice show' and properties = $1"
    param1 = "{\"practice_id\": #{practice_id}}"
    if duration == "30"
      sql += " and time >= $2"
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1], [nil, "#{Time.now - duration.to_i.days}"]])
    else
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1]])
    end
    records_array
  end

  def fetch_unique_visitors_by_practice_and_date(practice_id, date)
    sql = "select distinct user_id from ahoy_events where name = 'Practice show' and properties = $1 and date(time) = $2"
    param1 = "{\"practice_id\": #{practice_id}}"
    records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, param1], [nil, "#{date}"]])
    records_array.count
  end

  def get_practice_all_time_duration(practice_id)
    created_date = Practice.find(practice_id).created_at.to_date
    duration =  (DateTime.now() - created_date).to_i
    duration
  end


  def fetch_bookmarks_by_practice(practice_id, duration = "30")
    practice = Practice.find(practice_id)
    bookmarked = practice.user_practices.where(favorited: true)
    if duration == "30"
      return bookmarked.where('time_favorited >= ?', 30.days.ago).count
    else
      return bookmarked.count
    end
  end

  def fetch_adoptions_total_by_practice(practice_id, duration = "30", status = "")
    sql = "select count(*) as count from diffusion_histories dh join diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id where dh.practice_id = $1"
    if(duration == "30")
      sql += " and dh.created_at >= $2"
      if(status.length > 0)
        sql += " and dhs.status= $3"
        records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"], [nil, "#{Time.now - duration.to_i.days}"], [nil, "#{status}"]])
      else
        records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"], [nil, "#{Time.now - duration.to_i.days}"]])
      end
    else
      if(status.length > 0)
        sql += " and dhs.status= $2"
        records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"], [nil, "#{status}"]])
      else
        records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"]])
      end
    end
    records_array[0]["count"]
  end

  def fetch_adoptions_by_practice(practice_id, duration = "30")
    sql = "select count(*) as the_count from diffusion_histories where practice_id = $1"
    if duration == "30"
      sql += " and created_at >= $2"
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"], [nil, "#{Time.now - duration.to_i.days}"]])
    else
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"]])
    end
    records_array[0]["the_count"]
  end

  def fetch_adoption_facilities_for_practice(practice_id, duration="30", facility_data)
    facility_ids = []
    sql = "select va_facility_id from diffusion_histories where practice_id = $1"
    if duration == "30"
      sql += " and created_at >= $2"
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"], [nil, "#{Time.now - duration.to_i.days}"]])
    else
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"]])
    end
    records_array.each do |rec|
      facility_ids << facility_data.find(rec.values.first).station_number
    end
    facility_ids
  end

  def get_adoption_facility_details_for_practice(facility_data, facility_station_numbers_for_practice, key, value)
    match_counter = 0
    facility_data.where(station_number: facility_station_numbers_for_practice).each do |facility|
      if facility[key] === value
        match_counter += 1
      end
    end
    match_counter
  end

  def fetch_page_views_leader_board(duration = "30")
    page_view_leaders = []
    ctr = 0
    if duration == "30"
      sql = "select name, properties, count(properties) as count from ahoy_events where name = 'Practice show' and time >= now() - interval '30 days' group by name, properties order by count desc"
    else
      sql = "select name, properties, count(properties) as count from ahoy_events where name = 'Practice show' group by name, properties order by count desc"
    end
    records_array = ActiveRecord::Base.connection.execute(sql)

    recs = records_array.values
    recs.each do |rec|
      practice_id = JSON.parse(rec[1])['practice_id']
      practice = practice_leader_board(Practice.find(practice_id), rec[2])
      published = Practice.find(practice_id).published
      if published
        page_view_leaders << practice
        ctr += 1
        if ctr == 10
          return page_view_leaders
        end
      end
    end
    page_view_leaders
  end
end
