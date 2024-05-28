module PagesHelper
  # graceful fallbacks for <= 3 paginated components
  def column_size(item_count)
    case item_count
	when 1
	  return 'tablet:grid-col-12'
	when 2
	  return 'tablet:grid-col-6'
	else
	  return 'tablet:grid-col-4'
	end
  end
end