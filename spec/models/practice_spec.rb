require 'rails_helper'

RSpec.describe Practice, type: :model do
  describe 'associations' do
    it { should have_many(:ancillary_service_practices) }
    it { should have_many(:ancillary_services) }
    it { should have_many(:badge_practices) }
    it { should have_many(:badges) }
    it { should have_many(:clinical_condition_practices) }
    it { should have_many(:clinical_conditions) }
    it { should have_many(:clinical_location_practices) }
    it { should have_many(:clinical_locations) }
    it { should have_many(:developing_facility_type_practices) }
    it { should have_many(:developing_facility_types) }
    it { should have_many(:impact_practices) }
    it { should have_many(:impacts) }
    it { should have_many(:job_position_practices) }
    it { should have_many(:job_positions) }
    it { should have_many(:photo_files) }
    it { should have_many(:publications) }
    it { should have_many(:publication_files) }
    it { should have_many(:risk_and_mitigations) }
    it { should have_many(:strategic_sponsor_practices) }
    it { should have_many(:strategic_sponsors) }
    it { should have_many(:survey_result_files) }
    it { should have_many(:toolkit_files) }
    it { should have_many(:va_employee_practices) }
    it { should have_many(:va_employees) }
    it { should have_many(:va_secretary_priority_practices) }
    it { should have_many(:va_secretary_priorities) }
    it { should have_many(:video_files) }
  end
end
