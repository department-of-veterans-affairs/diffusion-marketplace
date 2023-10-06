module PracticesHelper
  def fetch_offices
    @office_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @office_data["departments"][0]["offices"].to_json
  end

  def is_url_internal?(s_url)
    internal_urls = ['marketplace.va.gov', 'localhost:3200']
    internal_urls.any? { |url| s_url.downcase.include?(url) }
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

  def display_practice_name(practice)
    if practice.short_name.present?
      "#{practice.name} (#{practice.short_name})"
    else
      practice.name
    end
  end

  def get_person_resource_text(resource_type)
    content = {
      'core': 'Type a job title, department, and/or discipline another facility would need to involve in
              implementing your innovation. Provide dependencies for implementation (e.g., Clinical Application Coordinator required for 2-4  hours/week for 1-2 weeks).',
      'optional': 'Type a job title, department, and/or discipline another facility could involve in
                  implementing your innovation. Provide dependencies for implementation (e.g., Clinical Application Coordinator required for 2-4  hours/week for 1-2 weeks).',
      'support': 'Type the job title of a role your team would provide to another facility, and describe the
                  support that will be provided.'
    }
    content[resource_type.to_sym]
  end

  def get_process_resource_text(resource_type)
    content = {
      'core': 'Type a process (e.g., method, procedure, training) another facility would need to implement
              your innovation.',
      'optional': 'Type a process (e.g., method, procedure) another facility can consider when implementing
                  your innovation.',
      'support': 'Type a process (e.g., method, procedure) your team would provide for another facility.'
    }
    content[resource_type.to_sym]
  end

  def get_tool_resource_text(resource_type)
    content = {
      'core': 'Type a tool (e.g., equipment, software, supply) another facility would need to implement your
              innovation.',
      'optional': 'Type a tool (e.g., equipment, software, supply) another facility can consider when
                  implementing your innovation.',
      'support': 'Type a tool (e.g., equipment, software, supply) your team would provide to another
                  facility.'
    }
    content[resource_type.to_sym]
  end

  def sort_adoptions_by_state_and_station_name(adoptions)
    sorted_by_facility = adoptions
      .exclude_clinical_resource_hubs
      .includes([:va_facility])
      .sort_by do |a|
        fac = a.va_facility
        [fac.street_address_state, fac.official_station_name.downcase]
      end

    sorted_by_visn = adoptions
      .exclude_va_facilities
      .sort_by { |a| a.clinical_resource_hub.visn.number }

    result = sorted_by_facility + sorted_by_visn
  end
end
