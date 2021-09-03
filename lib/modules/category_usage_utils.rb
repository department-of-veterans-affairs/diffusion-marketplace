module CategoryUsageUtils
  def get_top_six_categories
    #get top 6 from ahoy.events table - name: 'Selected category'




    # sql = "select cu.category_id, c.name, count(*) from category_usages cu join categories c on cu.category_id=c.id where cu.created_at >= (CURRENT_DATE - 90) group by cu.category_id, c.name order by count desc limit(6)"
    # ActiveRecord::Base.connection.execute(sql)
  end
end