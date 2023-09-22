require 'rails_helper'

RSpec.describe DiffusionHistory, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
    it { should have_many(:diffusion_history_statuses) }
  end

  describe 'scopes' do
    before(:all) do
      @in_progress = create_list(:diffusion_history, 3, :with_va_facility, :with_status_in_progress)
      @planning = create_list(:diffusion_history, 3, :with_va_facility, :with_status_planning)
      @implementing = create_list(:diffusion_history, 3, :with_va_facility, :with_status_implementing)
      @complete = create_list(:diffusion_history, 3, :with_va_facility, :with_status_complete)
      @completed = create_list(:diffusion_history, 3, :with_clinical_resource_hub, :with_status_completed)
      @implemented = create_list(:diffusion_history, 3, :with_clinical_resource_hub, :with_status_implemented)
      @unsuccessful = create_list(:diffusion_history, 3, :with_clinical_resource_hub, :with_status_unsuccessful)
      @with_public_practices = create_list(:diffusion_history, 3, :with_va_facility, :with_status_unsuccessful, practice: create(:practice, :public_practice))
      @with_private_practices = create_list(:diffusion_history, 3, :with_va_facility, :with_status_unsuccessful, practice: create(:practice, :private_practice))
    end

    describe '.by_status' do
      it 'returns diffusion histories with a given status' do
        implementing_dh = DiffusionHistory.by_status('Implementing').sort_by(&:id)
        completed_dh = DiffusionHistory.by_status('Completed').sort_by(&:id)

        expect(implementing_dh.count).to eq(3)
        expect(implementing_dh).to eq(@implementing.sort_by(&:id))

        expect(completed_dh.count).to eq(3)
        expect(completed_dh).to eq(@completed.sort_by(&:id))
      end
    end

    describe '.get_by_successful_status' do
      it 'returns diffusion histories with successful statuses' do
        successful_dh = DiffusionHistory.get_by_successful_status.sort_by(&:id)
        expect(successful_dh.count).to eq(9)
        expect(successful_dh).to eq((@complete + @completed + @implemented).sort_by(&:id))
      end
    end

    describe '.get_by_in_progress_status' do
      it 'returns diffusion histories with in-progress statuses' do
        in_progress_dh = DiffusionHistory.get_by_in_progress_status.sort_by(&:id)
        expect(in_progress_dh.count).to eq(9)
        expect(in_progress_dh).to eq((@in_progress + @planning + @implementing).sort_by(&:id))
      end
    end

    describe '.get_by_unsuccessful_status' do
      it 'returns diffusion histories with unsuccessful statuses' do
        unsuccessful_dh = DiffusionHistory.get_by_unsuccessful_status.sort_by(&:id)
        expect(unsuccessful_dh.count).to eq(9)
        expect(unsuccessful_dh).to eq((@unsuccessful + @with_private_practices + @with_public_practices).sort_by(&:id))
      end
    end

    describe '.get_with_practices' do
      it 'returns diffusion histories belonging to a public practice' do
        public_dhs = DiffusionHistory.get_with_practices(true).sort_by(&:id)
        expect(public_dhs.count).to eq(3)
        expect(public_dhs).to eq(@with_public_practices.sort_by(&:id))
      end

      it 'returns all diffusion histories belonging to a practice regardless of practice visibility' do
        all_dhs = DiffusionHistory.get_with_practices(false).sort_by(&:id)
        expect(all_dhs.count).to eq(6)
        expect(all_dhs).to eq((@with_public_practices + @with_private_practices).sort_by(&:id))
      end
    end

    describe '.get_va_facilities' do
      it 'returns station_numbers of va_facilities that DHs belong to' do
        existing_dh_va_facilities = DiffusionHistory.where.not(va_facility_id: nil)
        va_facility_station_numbers = existing_dh_va_facilities.map { |dh| dh.va_facility.station_number }

        expect(DiffusionHistory.get_va_facilities.compact).to match_array(va_facility_station_numbers)
      end
    end

    describe '.get_clinical_resource_hubs' do
      it 'returns station_names of clinical_resource_hubs that diffusion_histories belong to' do
        existing_dh_crhs = DiffusionHistory.where.not(clinical_resource_hub_id: nil)
        crh_station_names = existing_dh_crhs.map { |dh| dh.clinical_resource_hub.official_station_name }

        expect(DiffusionHistory.get_clinical_resource_hubs.compact).to match_array(crh_station_names)
      end
    end

    describe '.get_with_practice' do
      it 'returns dhs belonging to a specific practice' do
        practice = @with_public_practices.first.practice

        expect(DiffusionHistory.get_with_practice(practice).sort).to eq(@with_public_practices.sort)
      end
    end

    describe '.exclude_va_facilities' do
      it 'returns dhs that do not belong to a va_facility' do
        expect(DiffusionHistory.exclude_va_facilities.sort).to eq(@completed + @implemented + @unsuccessful)
      end
    end

    describe '.exclude_clinical_resource_hubs' do
      it 'returns dhs that do not belong to a clinical_resource_hub' do
        expect(DiffusionHistory.exclude_clinical_resource_hubs.sort).to eq(@in_progress + @planning + @implementing + @complete + @with_public_practices + @with_private_practices)
      end
    end
  end
end
