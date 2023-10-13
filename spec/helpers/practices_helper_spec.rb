require 'rails_helper'

RSpec.describe PracticesHelper, type: :helper do
    describe '#sort_adoptions_by_state_and_station_name' do
        let!(:va_facility_1) { create(:va_facility, street_address_state: 'CA', official_station_name: 'Facility A') }
        let!(:va_facility_2) { create(:va_facility, street_address_state: 'CA', official_station_name: 'Facility B') }
        let!(:va_facility_3) { create(:va_facility, street_address_state: 'TX', official_station_name: 'Facility C') }

        let!(:cr_hub_1) { create(:clinical_resource_hub) }
        let!(:cr_hub_2) { create(:clinical_resource_hub) }

        let!(:diffusion_history1) { create(:diffusion_history, va_facility: va_facility_1) }
        let!(:diffusion_history2) { create(:diffusion_history, va_facility: va_facility_2) }
        let!(:diffusion_history3) { create(:diffusion_history, va_facility: va_facility_3) }

        let!(:diffusion_history4) { create(:diffusion_history, clinical_resource_hub: cr_hub_1) }
        let!(:diffusion_history5) { create(:diffusion_history, clinical_resource_hub: cr_hub_2) }

        
        it 'sorts diffusion_histories by state and station name' do
            result = helper.sort_adoptions_by_state_and_station_name(DiffusionHistory.all)
            expect(result[0..2]).to eq([diffusion_history1,diffusion_history2,diffusion_history3])
        end

        it 'sorts diffusion_histories by VISN number' do
            result = helper.sort_adoptions_by_state_and_station_name(DiffusionHistory.all)
            expect(result[-2]).to eq(diffusion_history4)
            expect(result[-1]).to eq(diffusion_history5)
        end
    end
end