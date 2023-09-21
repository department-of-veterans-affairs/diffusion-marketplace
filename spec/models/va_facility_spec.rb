require 'rails_helper'

RSpec.describe VaFacility, type: :model do
  describe 'associations' do
    it { should belong_to(:visn) }
  end

  describe 'scopes' do
    let!(:visn_1) { create(:visn) }
    let!(:visn_2) { create(:visn) }

    let!(:facilities_1) { create_list(:va_facility, 10, visn: visn_1) }
    let!(:facilities_2) { create_list(:va_facility, 10, visn: visn_2) }

    describe '.get_by_visn' do
      it 'returns facilities associated with a given VISN' do
        expect(described_class.get_by_visn(visn_1)).to match_array(facilities_1)
        expect(described_class.get_by_visn(visn_2)).to match_array(facilities_2)
      end
    end

    describe '.get_classification_counts' do
      it 'returns the count of facilities with a given classification and hidden: false' do
        classification_type = facilities_1.first.classification
        expect(described_class.get_classification_counts(classification_type)).to eq(1)

        facilities_1.second.update!(classification: classification_type)
        facilities_2.first.update!(classification: classification_type)
        expect(described_class.get_classification_counts(classification_type)).to eq(3)
      end
    end

    describe '.get_classifications' do
      it 'returns an array of unique classifications' do
        all_facilities = facilities_1 + facilities_2
        unique_classifications = all_facilities.map(&:classification).uniq

        expect(described_class.get_classifications).to match_array(unique_classifications)
      end
    end

    describe '.get_ids' do
      it 'returns an array of ids for all facilities' do
        all_facilities = facilities_1 + facilities_2
        all_ids = all_facilities.map(&:id)

        expect(described_class.get_ids).to match_array(all_ids)
      end
    end

    describe '.get_locations' do
      it 'returns an array of unique state locations, ordered by state name' do
        all_facilities = facilities_1 + facilities_2
        unique_locations = all_facilities.map(&:street_address_state).uniq.sort

        expect(described_class.get_locations).to eq(unique_locations)
      end
    end

    describe '.get_complexity' do
      it 'returns an array of unique and ordered complexity levels' do
        all_facilities = facilities_1 + facilities_2
        facilities_2.first.update!(
          fy17_parent_station_complexity_level: facilities_1.first.fy17_parent_station_complexity_level
        )
        unique_complexities = all_facilities.map(&:fy17_parent_station_complexity_level).uniq.sort

        expect(described_class.get_complexity).to eq(unique_complexities)
      end
    end

    describe '.get_relevant_attributes' do
      it 'returns records with only the selected relevant attributes' do
        relevant_attributes = described_class.get_relevant_attributes.first.attributes.keys.sort
        expected_attributes = [
          "street_address_state", "official_station_name", "id", "visn_id",
          "common_name", "station_number", "latitude", "longitude", "slug",
          "fy17_parent_station_complexity_level", "rurality", "classification", 
          "station_phone_number", "sta3n"
        ].sort
        expect(relevant_attributes).to eq(expected_attributes)
      end
    end

    describe '.order_by_station_name' do
      it 'returns facilities ordered by their official_station_name' do
        ordered_facilities = described_class.order_by_station_name
        station_names = ordered_facilities.map(&:official_station_name)
        expect(station_names).to eq(station_names.sort)
      end
    end

    describe '.order_by_state_and_station_name' do
      it 'returns facilities ordered by their street_address_state and then by their official_station_name' do
        ordered_facilities = described_class.order_by_state_and_station_name
        ordered_states_and_names = ordered_facilities.map { |f| [f.street_address_state, f.official_station_name] }

        expected_order = ordered_states_and_names.sort_by { |state, name| [state, name] }

        expect(ordered_states_and_names).to eq(expected_order)
      end
    end
  end
end
