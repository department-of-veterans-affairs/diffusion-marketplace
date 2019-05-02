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

end
