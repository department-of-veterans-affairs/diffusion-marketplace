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
      it "returns 'flex-justify-end'" do
        mock_alignment = 'RiGht'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-end')
      end

      it "returns 'flex-justify-end'" do
        mock_alignment = 'right'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-end')
      end
    end

    context "when given a 'center' alignment" do
      it "returns 'flex-justify-center'" do
        mock_alignment = 'Center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-center')
      end

      it "returns 'flex-justify-center'" do
        mock_alignment = 'center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-center')
      end
    end

    context "when given a no or any other alignment" do
      it "returns an empty string" do
        mock_alignment = nil
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end

      it "returns 'flex-justify-center'" do
        mock_alignment = 'foobar'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end
    end
  end

  describe "#get_link_target_attribute" do
    context "when given a" do
      it "returns 'flex-justify-end'" do
        mock_alignment = 'RiGht'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-end')
      end

      it "returns 'flex-justify-end'" do
        mock_alignment = 'right'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-end')
      end
    end

    context "when given a 'center' alignment" do
      it "returns 'justify-center'" do
        mock_alignment = 'Center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-center')
      end

      it "returns 'flex-justify-center'" do
        mock_alignment = 'center'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('flex-justify-center')
      end
    end

    context "when given a no or any other alignment" do
      it "returns an empty string" do
        mock_alignment = nil
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end

      it "returns 'flex-justify-center'" do
        mock_alignment = 'foobar'
        expect(helper.get_grid_alignment_css_class(mock_alignment)).to eq('')
      end
    end
  end

  describe "#origin_display_name and #origin_display" do
    before do
      user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      @practice = Practice.create(name: 'test-practice', initiating_facility_type: 'facility', user: user)

      Visn.create!(id: 5, name: "VA Mid-Atlantic Health Care Network", number: 6)
      visn_8 = Visn.create!(id: 7, name: "VA Sunshine Healthcare Network", number: 8)
      visn_9 = Visn.create!(id: 8, name: "VA MidSouth Healthcare Network", number: 9)

      facility_1 = VaFacility.create!(visn: visn_8, station_number: "546", official_station_name: "Bruce W. Carter Department of Veterans Affairs Medical Center", common_name: "Miami", street_address_state: "FL")
      @facility_2 = VaFacility.create!(visn: visn_8, station_number: "516", official_station_name: "C.W. Bill Young Department of Veterans Affairs Medical Center", common_name: "Bay Pines", street_address_state: "FL")
      @facility_3 = VaFacility.create!(visn: visn_9, station_number: "614", official_station_name: "Memphis VA Medical Center", common_name: "Memphis", street_address_state: "TN")

      PracticeOriginFacility.create(practice: @practice, va_facility: facility_1, facility_type: 0)
    end

    context "when given a practice with a facility" do
      it "returns the name" do
        expect(helper.origin_display_name(@practice)).to eq('Bruce W. Carter Department of Veterans Affairs Medical Center (Miami)')
        expect(helper.origin_display(@practice)).to eq('by the Bruce W. Carter Department of Veterans Affairs Medical Center (Miami)')
      end
    end

    context "when given a practice with multiple facilities" do
      before do
        PracticeOriginFacility.create(practice: @practice, va_facility: @facility_2)
        PracticeOriginFacility.create(practice: @practice, va_facility: @facility_3)

      end
      it "returns the name" do
        expect(helper.origin_display_name(@practice)).to eq('Bruce W. Carter Department of Veterans Affairs Medical Center (Miami), C.W. Bill Young Department of Veterans Affairs Medical Center (Bay Pines), Memphis VA Medical Center')
        expect(helper.origin_display(@practice)).to eq('by the Bruce W. Carter Department of Veterans Affairs Medical Center (Miami), C.W. Bill Young Department of Veterans Affairs Medical Center (Bay Pines), Memphis VA Medical Center')
      end
    end

    context "when given a practice with a visn" do
      before do
        @practice.update(initiating_facility_type: 'visn', initiating_facility: '5')
      end
      it "returns the name" do
        expect(helper.origin_display_name(@practice)).to eq('VISN-6')
        expect(helper.origin_display(@practice)).to eq('by VISN-6')
      end
    end

    context "when given a practice with a department" do
      before do
        @practice.update(initiating_facility_type: 'department', initiating_facility: '36', initiating_department_office_id: 1)
      end
      it "returns the name" do
        expect(helper.origin_display_name(@practice)).to eq('Oakland Regional Office')
        expect(helper.origin_display(@practice)).to eq('by the Oakland Regional Office')
      end
    end

    context "when given a practice with a other" do
      before do
        @practice.update(initiating_facility_type: 'other', initiating_facility: 'foobar facility')
      end
      it "returns the name" do
        expect(helper.origin_display_name(@practice)).to eq('foobar facility')
        expect(helper.origin_display(@practice)).to eq('by the foobar facility')
      end
    end

    context "when given a practice with no intiating facility type" do
      before do
        @practice.update(initiating_facility_type: nil, initiating_facility: 'foobar')
      end
      it "returns an empty string" do
        expect(helper.origin_display_name(@practice)).to eq('')
        expect(helper.origin_display(@practice)).to eq('')
      end
    end

    context "when given a practice with intiating facility type but no initiating facility" do
      before do
        @practice.update(initiating_facility_type: 'other', initiating_facility: nil)
      end
      it "returns an empty string" do
        expect(helper.origin_display_name(@practice)).to eq('')
        expect(helper.origin_display(@practice)).to eq('')
      end
    end
  end

  describe "#get_terms_and_conditions_body_text" do
    context "when given no current user" do
      it "returns the terms and conditions text without `VA network` in it" do
        mock_current_user = nil
        expect(helper.get_terms_and_conditions_body_text(mock_current_user)).to eq("VA systems are intended to be used by authorized users for viewing and retrieving information; except as otherwise authorized for official business and limited personal use under VA policy. Information from this system resides on and transmits through computer systems and networks funded by VA. Access or use constitutes understanding and acceptance that there is no reasonable expectation of privacy in the use of Government networks or systems. Access or use of this system constitutes user understanding and acceptance of these terms and constitutes unconditional consent to review and action includes but is not limited to: monitoring; recording; copying; auditing; inspecting.")
      end
    end

    context "when given a current user" do
      it "returns the terms and conditions text with `VA network` in it" do
        mock_current_user = {id: 1}
        expect(helper.get_terms_and_conditions_body_text(mock_current_user)).to eq("VA systems are intended to be used by authorized VA network users for viewing and retrieving information; except as otherwise authorized for official business and limited personal use under VA policy. Information from this system resides on and transmits through computer systems and networks funded by VA. Access or use constitutes understanding and acceptance that there is no reasonable expectation of privacy in the use of Government networks or systems. Access or use of this system constitutes user understanding and acceptance of these terms and constitutes unconditional consent to review and action includes but is not limited to: monitoring; recording; copying; auditing; inspecting.")
      end
    end
  end
end
