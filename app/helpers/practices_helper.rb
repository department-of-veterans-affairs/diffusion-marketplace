module PracticesHelper
  def fetch_offices
    @office_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
    @office_data["departments"][0]["offices"].to_json
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

  def states_lookup
    @state_options = us_states
    x = 0
    state_hash_arr = []
      @state_options.each do |st|
        if x > 0
          st.split
          state_hash_arr << st[1] + "," + st[0]
        end
        x = x + 1
      end
      state_hash_arr
  end

  def get_visn_associated_states_str(visn_id)
    visn_associated_states = [VaFacility.select(:mailing_address_state).distinct.where(:visn_id => visn_id)]
    state_hash_array = states_lookup
    states_str = ""
    visn_associated_states[0].each do | vst |
      b_found = false
      state_hash_array.each do | st |
        cur_state = st.split(",")
        if cur_state[1] != nil && cur_state[0] === vst.mailing_address_state
          states_str += cur_state[1].to_s + ", "
          b_found = true
          next
        end
      end
      if b_found
        next
      end
    end
    ret_str = ""
    ctr = 1
    if states_str.length > 0
      states_str = states_str[0..-3]
      states_arr = states_str.split(",")
      states_arr.each do |st|
        if states_arr.length == ctr
          ret_str = ret_str[0..-2]
          ret_str += " and " + st
        else
          ret_str += st + ","
        end
        ctr += 1
      end
    end
    ret_str
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
    adoptions.exclude_clinical_resource_hubs.sort_by { |a| fac = a.va_facility; [fac.street_address_state, fac.official_station_name.downcase] } +
      adoptions.exclude_va_facilities.sort_by { |a| a.clinical_resource_hub.visn.number }
  end
end
