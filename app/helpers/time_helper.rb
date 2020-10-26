module TimeHelper
  def timeago(time)
    content_tag(:time, time.iso8601, class: 'timeago', datetime: time.iso8601, title: "#{time.in_time_zone('America/New_York').strftime("%B %e, %Y at %I:%M %p %Z")}")
  end
end