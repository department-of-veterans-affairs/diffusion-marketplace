module ApplicationHelper
  def date_format(date)
    date.in_time_zone.strftime "%B %Y"
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
    case aggregate
    when 2
      return 'Some complexity to implement'
    when 3
      return 'Significant complexity to implement'
    when 4
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
    facilities_data = facilities_data || @facilities_data
    facility_data = facilities_data.find {|f| f['StationNumber'] == facility_id }
    facility_data.present? ? facility_data['OfficialStationName'] : facility_id
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
    raw("Let's take the next steps to implement #{practice.name}: #{practice.tagline}, from the VA Diffusion Marketplace: %0D%0A%0D%0A#{ENV['HOSTNAME']}/practices/#{practice.slug}/next-steps%0D%0A%0D%0AAbout #{practice.name}: %0D%0A%0D%0A#{practice.description}%0D%0A%0D%0A#{practice.summary}%0D%0A%0D%0A")
  end

  def show_errors(object, field_name)
    if object.errors.any?
      if !object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(", ")
      end
    end
  end 

end
