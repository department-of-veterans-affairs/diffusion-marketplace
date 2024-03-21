start_date = ARGV[0]
end_date = ARGV[1]

def count_events(start_date, end_date, name, properties_condition = nil)
  query = Ahoy::Event.where(name: name)
  query = query.where("properties ->> 'from_homepage' = 'true'") if properties_condition
  query = query.where(time: start_date..end_date)
  query.count
end

output = "Date,Browse All,Innovations,Categories\n"

(Date.parse(start_date)..Date.parse(end_date)).each do |date|
  next_day = date + 1
  browse_all_count = count_events(date, next_day, "Dropdown Browse-all Link Clicked")
  innovations_count = count_events(date, next_day, "Dropdown Practice Link Clicked")
  categories_count = count_events(date, next_day, "Category selected", true)

  output += "#{date.strftime('%m-%d-%Y')},#{browse_all_count},#{innovations_count},#{categories_count}\n"
end

puts output