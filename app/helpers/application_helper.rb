module ApplicationHelper
  def date_format(date)
    date.in_time_zone.strftime "%B %Y"
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

    %Q{<div class="video-container"><iframe title="YouTube video player" width="700" height="405" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe></div>}.html_safe
  end

  def cost_aggregate_description(aggregate)
    case aggregate
    when 2
      return '$10,000-$50,000'
    when 3
      return '$50,000-$250,000'
    when 4
      return 'Over $250,000'
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
      return 'medium'
    when 4
      return 'high'
    else
      return ''
    end
  end

end
