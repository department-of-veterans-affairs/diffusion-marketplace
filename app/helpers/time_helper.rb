module TimeHelper
  def timeago(time)
    content_tag(:time, time.iso8601, class: 'timeago', datetime: time.iso8601)
  end
end