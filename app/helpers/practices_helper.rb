module PracticesHelper
  SATISFACTION_LABELS = ['Little or no impact', 'Some impact', 'Significant impact', 'High or large impact'].freeze
  COST_LABELS = ['0-$10,000', '$10,000-$50,000', '$50,000-$250,000', 'More than $250,000'].freeze
  DIFFICULTY_LABELS = ['Little or no difficulty to implement', 'Some difficulty to implement', 'Significant difficulty to implement', 'High or large difficulty to implement'].freeze
  TIME_ESTIMATE_OPTIONS =['1 week', '1 month', '3 months', '6 months', '1 year', 'longer than 1 year', 'Other (Please specify)']

  COMPLEXITY_LABELS = ['Little or no complexity', 'Some complexity', 'Significant complexity', 'High or large complexity'].freeze

  # TODO: what to do with these?
  # def gold_status_first_line
  #   gold_status_tagline.split('\n')[0]
  # end
  #
  # def gold_status_second_line
  #   gold_status_tagline.split('\n')[1]
  # end

  # chooses the highest rating of difficulty, sustainability, and number of departments
  def complexity_aggregate(practice)
    [practice.difficulty_aggregate || 0, practice.sustainability_aggregate || 0, practice.number_departments || 0].max
  end

  def departments_required_display(practice)
    one_to_three_departments = (1..3)
    department_count = practice.number_departments
    case
    when one_to_three_departments.cover?(department_count)
      return "#{department_count.humanize} department#{department_count == 1 ? '' : 's'}".humanize
    when department_count == 0
      return 'None'
    else
      return 'Four or more departments'
    end
  end

  def duration_of_job_display(practice)
    durations = practice.additional_staffs.map { |as| as.duration_in_weeks&.downcase }
    durations.include?('permanent') ? 'Permanent' : "#{durations.map { |d| d.to_i }.sum} weeks" if durations.any?
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

  def fetch_facility_ids_for_practice(practice_id, duration="30")
    facility_ids = []
    sql = "select facility_id from diffusion_histories where practice_id = $1"
    if duration == "30"
      sql += " and created_at >= $2"
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"], [nil, "#{Time.now - duration.to_i.days}"]])
    else
      records_array = ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{practice_id}"]])
    end
    records_array.each do |rec|
      facility_ids << rec["facility_id"]
    end
    facility_ids
  end

  def get_facility_details_for_practice(facility_data, facility_ids_for_practice, key, value)
    match_counter = 0
    rec_counter = 0
    facility_data.each do |fac|
      facility_ids_for_practice.each do |fid|
        if fid == fac["StationNumber"]
          if fac[key] == value.to_s
            match_counter += 1
            next
          end
        end
      end
      rec_counter += 1
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

  def fetch_offices
    @office_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @office_data["departments"][0]["offices"].to_json
  end

  def fetch_vamc_facilities
    @vamc_facility_data = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
  end

  def departments_for_select
    @department_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @department_data = @department_data["departments"]
    @department_data.map {|c| [ c['name'], c['id'] ] }
  end

  def offices_for_select
    @office_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @office_data = @office_data["departments"][0]["offices"]
    @office_data.map {|c| [ c['name'], c['id'] ] }
  end
  def fetch_visns
    @visn_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @visn_data = @visn_data["visns"]
  end
  def visns_for_select
    @visn_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @visn_data = @visn_data["visns"]
    @visn_data.map {|c| [ c['number'], c['id'] ] }
  end
  def options_for_states
    @state_options = us_states
    x = 0
    state_hash_str = ""
    @state_options.each do |st|
      if x > 0
        st.split
        state_hash_str += st[1] + ":" + st[0] + ","
      end
      x = x + 1
    end
    state_hash_str
  end

  def get_all_awards(practice)
    all_awards = ""
    practice_awards = practice.practice_awards.where.not(name: 'Other')
    practice_awards.each_with_index do |award, index|
      if all_awards.length == 0
        all_awards = award.name.to_s
      else
        all_awards += award.name.to_s
      end
      if practice_awards.length != index + 1 && practice.practice_awards.length > 1
        all_awards += ", "
      end
    end
    all_awards.to_s
  end

  def display_practice_name(practice)
    if practice.short_name.present?
      "#{practice.name} (#{practice.short_name})"
    else
      practice.name
    end
  end

  # search terms refers to campaigns/categories/tags
  def get_all_search_terms(practice)
    all_terms = []
    # TODO: Add both campaigns and tags to this code
    practice_categories = practice.categories.where.not(is_other: true, name: 'Other')
    practice_categories.each do |category|
      all_terms.push(category.name)
    end
    all_terms
  end

  def slice_terms(practice)
    terms = get_all_search_terms(practice)
    terms.slice(0..9)
  end

  def get_remaining_terms_if_sliced(practice)
    terms = get_all_search_terms(practice)
    terms.slice(10..-1)
  end

  def get_person_resource_text(resource_type)
    content = {
      'core': 'Type a job title, department, and/or discipline another facility would need to involve in
              implementing your practice. Provide dependencies for implementation (e.g., Clinical Application Coordinator required for 2-4  hours/week for 1-2 weeks).',
      'optional': 'Type a job title, department, and/or discipline another facility could involve in
                  implementing your practice. Provide dependencies for implementation (e.g., Clinical Application Coordinator required for 2-4  hours/week for 1-2 weeks).',
      'support': 'Type the job title of a role your team would provide to another facility, and describe the
                  support that will be provided.'
    }
    content[resource_type.to_sym]
  end

  def get_process_resource_text(resource_type)
    content = {
      'core': 'Type a process (e.g., method, procedure, training) another facility would need to implement
              your practice.',
      'optional': 'Type a process (e.g., method, procedure) another facility can consider when implementing
                  your practice.',
      'support': 'Type a process (e.g., method, procedure) your team would provide for another facility.'
    }
    content[resource_type.to_sym]
  end

  def get_tool_resource_text(resource_type)
    content = {
      'core': 'Type a tool (e.g., equipment, software, supply) another facility would need to implement your
              practice.',
      'optional': 'Type a tool (e.g., equipment, software, supply) another facility can consider when
                  implementing your practice.',
      'support': 'Type a tool (e.g., equipment, software, supply) your team would provide to another
                  facility.'
    }
    content[resource_type.to_sym]
  end
end
