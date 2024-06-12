module ThreeColumnDataHelper
  def split_data_into_three_columns(data_set)
    flat_data_set = data_set.to_a.flatten
    count_per_column = (flat_data_set.size + 2) / 3
    sliced_data_set = Array.new(3) { |i| flat_data_set[i * count_per_column, count_per_column] || [] }
    if flat_data_set.size % 3
      sliced_data_set[1] << sliced_data_set[2].shift if sliced_data_set[2].any?
    end
    sliced_data_set
  end
end
