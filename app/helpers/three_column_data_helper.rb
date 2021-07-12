module ThreeColumnDataHelper
  def split_data_into_three_columns(data_set)
    if data_set.count > 1
      # Divide the total by three and round up if possible to make sure the data is evenly distributed amongst the columns
      count = ((data_set.count * 2) + 3) / (3 * 2)
      sliced_data_set = data_set.each_slice(count).to_a

      # When the data set count is divisible by 3 with a remainder of 1, move item(s) from one array to the previous to maintain distribution
      if data_set.count % 3 == 1
        sliced_data_set[2].insert(-1, sliced_data_set[3][0])
        sliced_data_set[1].insert(-1, sliced_data_set[2][0], sliced_data_set[2][1])
        sliced_data_set[0].insert(-1, sliced_data_set[1][0])
        sliced_data_set[2].shift(2)
        sliced_data_set[1].shift
      end

      sliced_data_set
    end
  end
end