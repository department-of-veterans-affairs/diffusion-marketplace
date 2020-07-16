module ApplicationHelper
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

  def content_type(attachment)
    return 'DOCX' if is_word_doc?(attachment)
    'PDF' if is_pdf?(attachment)
  end

  def is_word_doc?(attachment)
    attachment.instance.attachment_content_type =~ %r(word)
  end

  def is_pdf?(attachment)
    attachment.instance.attachment_content_type =~ %r(pdf)
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

  def cost_aggregate_description(aggregate)
    case aggregate
    when 2
      return '$10,000-$50,000'
    when 3
      return '$50,000-$250,000'
    when 4
      return 'More than $250,000'
    else
      return '$0-$10,000'
    end
  end

  def complexity_aggregate_description(aggregate)
    case
    when aggregate == 2
      return 'Some complexity to implement'
    when aggregate == 3
      return 'Significant complexity to implement'
    when aggregate >= 4
      return 'High or large complexity to implement'
    else
      return 'Little to no complexity to implement'
    end
  end

  def level_aggregate_style(aggregate)
    case aggregate
    when 2
      return 'medium'
    when 3
      return 'medium-high'
    when 4
      return 'high'
    else
      return ''
    end
  end

  def facility_name(facility_id, facilities_data = nil)
    facilities_data = facilities_data || @facilities_data || facilities_data_json
    facility_data = @facility_data || facilities_data.find {|f| f['StationNumber'] == facility_id }
    if facility_data.present?
      common_name = show_common_name(facility_data["OfficialStationName"], facility_data["CommonName"])
      facility_data["OfficialStationName"] + (common_name.present? ? " #{common_name}" : '')
    else
      facility_id
    end
  end

  def facilities_data_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
  end

  def origin_data_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_lookup.json"))
  end

  def origin_display_name(practice)
    if practice.initiating_facility_type?
      if practice.facility? && practice.practice_origin_facilities.any?
        fac_type = Practice.initiating_facility_types[practice.initiating_facility_type]
        locs = practice.practice_origin_facilities.where(facility_type: fac_type)
        facility_names = String.new
        locs.each_with_index do |loc, index|
          facility_names += (facility_name(loc.facility_id) + (locs.size != index + 1 && locs.size > 1 ? ', ' : ''))
        end
        facility_names
      elsif practice.initiating_facility?
      # TODO: Modify once visn, dept, other is moved from Practice to a separate table
        case practice.initiating_facility_type
        when 'visn'
          visn = origin_data_json['visns'].find { |v| v['id'] == practice.initiating_facility.to_i }
          visn['number']
        when 'department'
          dept_id = practice.initiating_department_office_id
          office = origin_data_json['departments'][dept_id - 1]['offices'].find { |o| o['id'] == practice.initiating_facility.to_i }
          office['name']
        when 'other'
          practice.initiating_facility
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
    URI.encode("VA Diffusion Marketplace - #{practice.name} summary")
  end

  def email_practice_body(practice)
    raw("Check out this practice, #{practice.name}: #{practice.tagline}, on the VA Diffusion Marketplace: %0D%0A%0D%0A#{ENV['HOSTNAME']}/practices/#{practice.slug}%0D%0A%0D%0AAbout #{practice.name}: %0D%0A%0D%0A#{practice.description}%0D%0A%0D%0A#{practice.summary}%0D%0A%0D%0A")
  end

  def email_checklist_subject(practice)
    URI.encode("VA Diffusion Marketplace - #{practice.name} checklist")
  end

  def email_checklist_body(practice)
    raw("Let's take the next steps to implement #{practice.name}: #{practice.tagline}, from the VA Diffusion Marketplace: %0D%0A%0D%0A#{ENV['HOSTNAME']}/practices/#{practice.slug}/planning-checklist%0D%0A%0D%0AAbout #{practice.name}: %0D%0A%0D%0A#{practice.summary}%0D%0A%0D%0A")
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
      'justify-center'
    elsif alignment&.downcase == 'right'
      'justify-end'
    else
      ''
    end
  end

  def get_link_target_attribute(url)
    if url.include?(ENV.fetch('HOSTNAME'))
      ''
    else
      '_blank'
    end
  end
end
