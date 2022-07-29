module ApplicationHelper
  include Pagy::Frontend
  include PracticeEditorUtils

  def date_format(date)
    date.in_time_zone.strftime "%B %Y"
  end

  def month_year_date_format(date)
    date.in_time_zone.strftime "%m/%Y"
  end

  def date_get_month(date)
    date.strftime('%m').to_i
  end

  def date_get_year(date)
    date.strftime('%Y').to_i
  end

  def youtube_embed(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end

    %Q{<div class="video-container"><iframe title="YouTube video player" width="700" height="405" src="https://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe></div>}.html_safe
  end

  def facility_name_with_common_name(official_station_name, common_name)
    common_name = show_common_name(official_station_name, common_name)
    official_station_name + (common_name.present? ? " #{common_name}" : '')
  end

  def origin_data_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
  end

  def origin_display_name_trunc(practice, start_char=0,  num_chars=180)
    origin_display_name(practice)[start_char...num_chars]
  end

  def overview_statement(statement, start_char=0,  num_chars=360)
    safe_join(raw(statement[start_char...num_chars]).split("\r\n"), tag(:br))
  end

  def origin_display_name(practice)
    if practice.initiating_facility_type?
      if practice.facility? && practice.practice_origin_facilities.present?
        fac_type = Practice.initiating_facility_types[practice.initiating_facility_type]
        locs = practice.practice_origin_facilities.includes([:va_facility, :clinical_resource_hub]).where(facility_type: fac_type)
        facility_names = String.new
        locs.each_with_index do |loc, index|
          has_va_facility = loc.va_facility.present?
          official_station_name = has_va_facility ? loc.va_facility.official_station_name : loc.clinical_resource_hub.official_station_name
          common_name = loc.va_facility.common_name if has_va_facility

          facility_names += "#{has_va_facility ? facility_name_with_common_name(official_station_name, common_name) : official_station_name}#{', ' if locs.size != index + 1 && locs.size > 1}"
        end
        facility_names
      elsif practice.initiating_facility?
      # TODO: Modify once visn, dept, other is moved from Practice to a separate table
        case practice.initiating_facility_type
        when 'visn'
          visn = Visn.get_by_initiating_facility(practice.initiating_facility.to_i)
          return "VISN-#{visn.number.to_s}"
        when 'department'
          dept_id = practice.initiating_department_office_id
          office = origin_data_json['departments'][dept_id - 1]['offices'].find { |o| o['id'] == practice.initiating_facility.to_i }
          office['name']
        when 'other'
          practice.initiating_facility
        else
          ''
        end
      else
        ''
      end
    else
      ''
    end
  end

  def origin_display(practice)
    display_name = origin_display_name(practice)
    if display_name.present?
      practice.visn? ? "by #{display_name}" : "by the #{display_name}"
    else
      ''
    end
  end

  def email_practice_subject(practice)
    url_generator("VA Diffusion Marketplace - #{practice.name} summary")
  end

  def email_practice_body(practice)
    raw("Check out this practice, #{practice.name}: #{practice.tagline}, on the VA Diffusion Marketplace: %0D%0A%0D%0A#{ENV['HOSTNAME']}/innovations/#{practice.slug}%0D%0A%0D%0AAbout #{practice.name}: %0D%0A%0D%0A#{practice.description}%0D%0A%0D%0A#{practice.summary}%0D%0A%0D%0A")
  end

  def show_errors(object, field_name)
    if object.errors.any?
      if !object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(", ")
      end
    end
  end

  def show_common_name(official_name, common_name)
    unless official_name.downcase.include?(common_name.downcase)
      "(#{common_name})"
    end
  end

  def get_grid_alignment_css_class(alignment)
    if alignment&.downcase == 'center'
      'flex-justify-center'
    elsif alignment&.downcase == 'right'
      'flex-justify-end'
    else
      ''
    end
  end

  def get_link_target_attribute(url)
    if url.include?(ENV.fetch('HOSTNAME')) || url.start_with?('/') || url.start_with?('.')
      ''
    else
      '_blank'
    end
  end

  def get_terms_and_conditions_body_text(current_user)
    "VA systems are intended to be used by authorized#{current_user.present? ? ' VA network ' : ' '}users for viewing and retrieving information; except as otherwise authorized for official business and limited personal use under VA policy. Information from this system resides on and transmits through computer systems and networks funded by VA. Access or use constitutes understanding and acceptance that there is no reasonable expectation of privacy in the use of Government networks or systems. Access or use of this system constitutes user understanding and acceptance of these terms and constitutes unconditional consent to review and action includes but is not limited to: monitoring; recording; copying; auditing; inspecting."
  end

  def url_generator(string)
    parser = URI::Parser.new
    parser.escape(string)
  end

  def get_facility_locations_by_visn(visn)
    sorted_facility_locations = VaFacility.get_by_visn(visn).get_locations.sort
    location_list = ''

    # Add other US territories to us_states helper method array
    va_facility_locations = us_states.concat(
        [
            ["Virgin Islands", "VI"],
            ["Philippines Islands", "PI"],
            ["Guam", "GU"],
            ["American Samoa", "AS"]
        ]
    )

    # iterate through the facility locations and add text
    sorted_facility_locations.each do |sfl|
      va_facility_locations.each do |vfl|
        full_name = vfl.first === "Virgin Islands" || vfl.first === "Philippines Islands" ? "the #{vfl.first}" : vfl.first
        if vfl[1] === sfl
          if sorted_facility_locations.count > 1 && sorted_facility_locations.last === sfl
            location_list += "and #{full_name}"
          elsif sorted_facility_locations.count > 2
            location_list += "#{full_name}, "
          else
            location_list += sorted_facility_locations.count == 1 ? "#{full_name}" : "#{full_name} "
          end
        end
      end
    end
    location_list
  end
end
