module CategoryUsageUtils
  def get_top_six_categories
    sql = "select cu.category_id, c.name, count(*) from category_usages cu join categories c on cu.category_id=c.id group by cu.category_id, c.name order by count desc limit(6)"
    records_array = ActiveRecord::Base.connection.execute(sql)
    records_array
  end
end