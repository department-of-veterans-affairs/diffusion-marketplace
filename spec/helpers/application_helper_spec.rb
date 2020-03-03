require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#date_get_month" do
    context "when given a date" do
      it "returns the month of that date as an integer" do
        mock_date = Date.new(2012, 10, 30)
        expect(helper.date_get_month(mock_date)).to eq(10)
      end
    end
  end

  describe "#date_get_year" do
    context "when given a date" do
      it "returns the year of that date as an integer" do
        mock_date = Date.new(2012, 10, 30)
        expect(helper.date_get_year(mock_date)).to eq(2012)
      end
    end
  end
end
