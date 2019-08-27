# frozen_string_literal: true

module ApplicationHelper
  def date_format(date)
    date.in_time_zone.strftime '%B %Y'
  end

  def content_type(attachment)
    return 'DOCX' if is_word_doc?(attachment)

    'PDF' if is_pdf?(attachment)
  end

  def is_word_doc?(attachment)
    attachment.instance.attachment_content_type =~ /word/
  end

  def is_pdf?(attachment)
    attachment.instance.attachment_content_type =~ /pdf/
  end

  def youtube_embed(youtube_url)
    if youtube_url[%r{youtu\.be/([^\?]*)}]
      youtube_id = Regexp.last_match(1)
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      youtube_url[%r{^.*((v/)|(embed/)|(watch\?))\??v?=?([^\&\?]*).*}]
      youtube_id = Regexp.last_match(5)
    end

    %(<div class="video-container"><iframe title="YouTube video player" width="700" height="405" src="https://www.youtube.com/embed/#{youtube_id}" frameborder="0" allowfullscreen></iframe></div>).html_safe
  end

  def cost_aggregate_description(aggregate)
    case aggregate
    when 2
      '$10,000-$50,000'
    when 3
      '$50,000-$250,000'
    when 4
      'Over $250,000'
    else
      '$0-$10,000'
    end
  end

  def complexity_aggregate_description(aggregate)
    case aggregate
    when 2
      'Some complexity to implement'
    when 3
      'Significant complexity to implement'
    when 4
      'High or large complexity to implement'
    else
      'Little to no complexity to implement'
    end
  end

  def level_aggregate_style(aggregate)
    case aggregate
    when 2
      'medium'
    when 3
      'medium-high'
    when 4
      'high'
    else
      ''
    end
  end

  def facility_name(facility_id, facilities_data = nil)
    facilities_data ||= @facilities_data
    facility_data = facilities_data.find { |f| f['properties']['id'] == facility_id }
    facility_data.present? ? facility_data['properties']['name'] : facility_id
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
end
