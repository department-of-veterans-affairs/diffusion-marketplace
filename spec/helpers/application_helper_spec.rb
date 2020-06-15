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

  describe "#get_grid_alignment_css_class" do
    context "when given a 'right' alignment" do
      it "returns 'justify-end'" do
        mock_alignment = 'RiGht'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-end')
      end

      it "returns 'justify-end'" do
        mock_alignment = 'right'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-end')
      end
    end

    context "when given a 'center' alignment" do
      it "returns 'justify-center'" do
        mock_alignment = 'Center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-center')
      end

      it "returns 'justify-center'" do
        mock_alignment = 'center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-center')
      end
    end

    context "when given a no or any other alignment" do
      it "returns an empty string" do
        mock_alignment = nil
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end

      it "returns 'justify-center'" do
        mock_alignment = 'foobar'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end
    end
  end

  describe "#get_link_target_attribute" do
    context "when given a" do
      it "returns 'justify-end'" do
        mock_alignment = 'RiGht'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-end')
      end

      it "returns 'justify-end'" do
        mock_alignment = 'right'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-end')
      end
    end

    context "when given a 'center' alignment" do
      it "returns 'justify-center'" do
        mock_alignment = 'Center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-center')
      end

      it "returns 'justify-center'" do
        mock_alignment = 'center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('justify-center')
      end
    end

    context "when given a no or any other alignment" do
      it "returns an empty string" do
        mock_alignment = nil
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end

      it "returns 'justify-center'" do
        mock_alignment = 'foobar'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end
    end
  end
end
