require 'rails_helper'

RSpec.describe ThreeColumnDataHelper, type: :helper do
  describe '#split_data_into_three_columns' do
    test_cases = {
      "empty set" => { input: [], output: [[], [], []] },
      "one element" => { input: [1], output: [[1], [], []] },
      "two elements" => { input: [1, 2], output: [[1], [2], []] },
      "three elements" => { input: [1, 2, 3], output: [[1], [2], [3]] },
      "four elements" => { input: [1, 2, 3, 4], output: [[1, 2], [3], [4]] },
      "five elements" => { input: [1, 2, 3, 4, 5], output: [[1, 2], [3, 4], [5]] },
      "six elements" => { input: [1, 2, 3, 4, 5, 6], output: [[1, 2], [3, 4], [5, 6]] },
      "seven elements" => { input: [1, 2, 3, 4, 5, 6, 7], output: [[1, 2, 3], [4, 5], [6, 7]] },
      "eight elements" => { input: [1, 2, 3, 4, 5, 6, 7, 8], output: [[1, 2, 3], [4, 5, 6], [7, 8]] },
      "nine elements" => { input: [1, 2, 3, 4, 5, 6, 7, 8, 9], output: [[1, 2, 3], [4, 5, 6], [7, 8, 9]] }
    }

    test_cases.each do |name, params|
      context "when the data set has #{name}" do
        it "splits the data into three columns as expected" do
          expect(helper.split_data_into_three_columns(params[:input])).to eq(params[:output])
        end
      end
    end
  end
end