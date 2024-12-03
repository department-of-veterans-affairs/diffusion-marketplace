module PracticeUtils
  def practices_json(practices, current_user=nil)
    practices_array = []

    practices.each do |practice|
      modified_practice = practice.as_json
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
      categories = p.categories.not_none
      categories.each do |c|
        practice_categories << c unless practice_categories.include?(c)
      end
    end
    practice_categories.sort_by! { |pc| pc.name.downcase }
  end

  def practice_leader_board(practice, count, created_at = DateTime.now())
    {practice_name: practice.name, practice_slug: practice.slug, count: count, created_at: created_at}
  end

  def fetch_page_views_for_practice_over_duration(practice_id, duration = "30")
    start_date = Time.now - duration.to_i.days
    Ahoy::Event.practice_views_for_single_practice_by_date_range(practice_id, start_date, Time.now)
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

  def get_adoption_facility_details_for_practice(facility_data, facility_station_numbers_for_practice, key, value)
    match_counter = 0
    facility_data.where(station_number: facility_station_numbers_for_practice).each do |facility|
      if facility[key] === value
        match_counter += 1
      end
    end
    match_counter
  end

  def calculate_adoption_metrics(adoptions)
    {
      successful: adoptions.get_by_successful_status.size,
      in_progress: adoptions.get_by_in_progress_status.size,
      unsuccessful: adoptions.get_by_unsuccessful_status.size
    }
  end

  def calculate_facility_metrics(facilities, facility_ids)
    {
      rural: get_adoption_facility_details_for_practice(facilities, facility_ids, "rurality", "R"),
      urban: get_adoption_facility_details_for_practice(facilities, facility_ids, "rurality", "U"),
      high_complexity_1a: get_adoption_facility_details_for_practice(facilities, facility_ids, "fy17_parent_station_complexity_level", "1a-High Complexity"),
      high_complexity_1b: get_adoption_facility_details_for_practice(facilities, facility_ids, "fy17_parent_station_complexity_level", "1b-High Complexity"),
      high_complexity_1c: get_adoption_facility_details_for_practice(facilities, facility_ids, "fy17_parent_station_complexity_level", "1c-High Complexity"),
      medium_complexity_2: get_adoption_facility_details_for_practice(facilities, facility_ids, "fy17_parent_station_complexity_level", "2 -Medium Complexity"),
      low_complexity_3: get_adoption_facility_details_for_practice(facilities, facility_ids, "fy17_parent_station_complexity_level", "3 -Low Complexity")
    }
  end

  def calculate_page_view_metrics(page_views, duration)
    grouped_page_views = page_views.group_by { |pv| pv.time.to_date }
    dates = (duration.to_i.days.ago.to_date..Date.today).map(&:to_s)
    views = dates.map { |date| grouped_page_views[Date.parse(date)]&.count || 0 }
    unique_visitors = dates.map { |date| grouped_page_views[Date.parse(date)]&.map(&:user_id)&.uniq&.count || 0 }

    { dates: dates, views: views, unique_visitors: unique_visitors }
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
