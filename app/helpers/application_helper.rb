module ApplicationHelper
  def date_format(date)
    date.in_time_zone.strftime "%B %Y"
  end
end
