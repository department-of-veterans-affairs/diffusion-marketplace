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

  describe "#show_common_name" do
    context "when given an official name that contains the common name" do
      it "does not return the common name" do
        mock_official_name = 'Chicago-illinois Medical Center'
        mock_common_name = 'Chicago-Illinois'
        expect(helper.show_common_name(mock_official_name, mock_common_name)).to eq(nil)
      end

      it "does not return the common name" do
        mock_official_name = 'Chicago-illinois Medical Center'
        mock_common_name = 'Chicago-Illinois'
        expect(helper.show_common_name(mock_official_name, mock_common_name)).to eq(nil)
      end
    end

    context "when given an official name that does not contain the common name" do
      it "returns the common name" do
        mock_official_name = 'Jesse Brown Department of Veterans Affairs Medical Center'
        mock_common_name = 'Chicago-Illinois'
        expect(helper.show_common_name(mock_official_name, mock_common_name)).to eq('(Chicago-Illinois)')
      end

      it "returns the common name" do
        mock_official_name = 'Arlington Memorial Medical Center'
        mock_common_name = 'Arlington Virginia'
        expect(helper.show_common_name(mock_official_name, mock_common_name)).to eq('(Arlington Virginia)')
      end
    end
  end
end
