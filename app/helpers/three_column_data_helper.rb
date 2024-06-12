module ThreeColumnDataHelper
  def split_data_into_three_columns(data_set)
    flat_data_set = data_set.to_a.flatten
    n = flat_data_set.size
    base_count = n / 3
    remainder = n % 3

    sliced_data_set = Array.new(3) { |i|
      start_index = (i * base_count) + [i, remainder].min
      end_index = start_index + base_count - 1 + (i < remainder ? 1 : 0)
      flat_data_set[start_index..end_index] || []
    }
    sliced_data_set
  end
end
