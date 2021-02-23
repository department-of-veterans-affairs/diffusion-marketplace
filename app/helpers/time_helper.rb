module TimeHelper
  def timeago(time)
    content_tag(:time, time.iso8601, class: 'timeago', datetime: time.iso8601, title: "#{time.in_time_zone('America/New_York').strftime("%B %e, %Y at %I:%M %p %Z")}")
  end

  def get_local_date_and_time(date_time)
    local_time(date_time, "%B %e, %Y at %l:%M %p")
  end
end