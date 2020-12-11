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

  def fetch_page_view_leader_board(duration = 30, limit = 10)
    page_view_leaders = []
    sql = "select name, properties, count(properties) as count from ahoy_events where name = 'Practice show' and time >= now() - interval '{#{duration} days' group by name, properties order by count desc limit #{limit}"
    records_array = ActiveRecord::Base.connection.execute(sql)

    recs = records_array.values
    recs.each do |rec|
      practice_id = JSON.parse(rec[1])['practice_id']
      leader = PracticeLeaderBoard.new
      leader.practice_name = Practice.find(practice_id).name
      leader.count = rec[2]
      page_view_leaders << leader
    end
    page_view_leaders
  end

  def fetch_offices
    @office_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @office_data["departments"][0]["offices"].to_json
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
