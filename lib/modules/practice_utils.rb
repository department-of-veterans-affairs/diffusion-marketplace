module PracticeUtils
  def practices_json(practices, current_user=nil)
    practices_array = []

    practices.each do |practice|
      modified_practice = practice.as_json
      modified_practice[:placeholder_image] = practice.main_display_image? ? practice.main_display_image_s3_presigned_url(:thumb) : ''
      modified_practice[:image] = practice.main_display_image&.path || ''
      if current_user.present?
        modified_practice[:user_favorited] = current_user.favorite_practice_ids.include?(practice[:id])
      end
      practices_array.push modified_practice
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

  def fetch_adoptions_by_practice_last_30_days(practice)
    DiffusionHistory.get_with_practice(practice).where(created_at: Time.now.beginning_of_day - 30.days..Time.now)
  end

  def fetch_adoptions_by_practice_all_time(practice)
    DiffusionHistory.get_with_practice(practice)
  end

  def fetch_adoption_counts_by_status(status, adoptions)
    case status
    when 'Completed'
      adoptions.get_by_successful_status.size
    when 'In progress'
      adoptions.get_by_in_progress_status.size
    when 'Unsuccessful'
      adoptions.get_by_unsuccessful_status.size
    end
  end

  def fetch_adoptions_total_by_practice_and_status_last_30_days(practice, status)
    adoptions = fetch_adoptions_by_practice_last_30_days(practice)
    fetch_adoption_counts_by_status(status, adoptions)
  end

  def fetch_adoptions_total_by_practice_and_status_all_time(practice, status)
    adoptions = fetch_adoptions_by_practice_all_time(practice)
    fetch_adoption_counts_by_status(status, adoptions)
  end

  def fetch_adoption_counts_by_practice_last_30_days(practice)
    DiffusionHistory.get_with_practice(practice).where(created_at: Time.now.beginning_of_day - 30.days..Time.now).size
  end

  def fetch_adoption_counts_by_practice_all_time(practice)
    DiffusionHistory.get_with_practice(practice).size
  end

  def fetch_adoption_facilities_for_practice_last_30_days(practice)
    DiffusionHistory.get_with_practice(practice).where(created_at: Time.now.beginning_of_day - 30.days..Time.now).includes(:va_facility).collect { |dh| dh.va_facility.station_number if dh.va_facility.present? }
  end

  def fetch_adoption_facilities_for_practice_all_time(practice)
    DiffusionHistory.get_with_practice(practice).includes(:va_facility).collect { |dh| dh.va_facility.station_number if dh.va_facility.present? }
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
