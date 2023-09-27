require 'rails_helper'

RSpec.describe Practice, type: :model do
  describe 'associations' do
    it { should have_many(:additional_documents) }
    it { should have_many(:additional_staffs) }
    it { should have_many(:additional_resources) }
    it { should have_many(:ancillary_service_practices) }
    it { should have_many(:ancillary_services) }
    it { should have_many(:badge_practices) }
    it { should have_many(:badges) }
    it { should have_many(:business_case_files) }
    it { should have_many(:category_practices) }
    it { should have_many(:categories) }
    it { should have_many(:checklist_files) }
    it { should have_many(:clinical_condition_practices) }
    it { should have_many(:clinical_conditions) }
    it { should have_many(:clinical_location_practices) }
    it { should have_many(:clinical_locations) }
    it { should have_many(:costs) }
    it { should have_many(:department_practices) }
    it { should have_many(:departments) }
    it { should have_many(:developing_facility_type_practices) }
    it { should have_many(:developing_facility_types) }
    it { should have_many(:difficulties) }
    it { should have_many(:domain_practices) }
    it { should have_many(:domains) }
    it { should have_many(:financial_files) }
    it { should have_many(:impact_photos) }
    it { should have_many(:job_position_practices) }
    it { should have_many(:job_positions) }
    it { should have_many(:photo_files) }
    it { should have_many(:practice_management_practices) }
    it { should have_many(:practice_managements) }
    it { should have_many(:publications) }
    it { should have_many(:publication_files) }
    it { should have_many(:required_staff_trainings) }
    it { should have_many(:risk_mitigations) }
    it { should have_many(:practice_partner_practices) }
    it { should have_many(:practice_partners) }
    it { should have_many(:practice_permissions) }
    it { should have_many(:survey_result_files) }
    it { should have_many(:timelines) }
    it { should have_many(:toolkit_files) }
    it { should have_many(:user_practices) }
    it { should have_many(:users) }
    it { should have_many(:va_employee_practices) }
    it { should have_many(:va_employees) }
    it { should have_many(:va_secretary_priority_practices) }
    it { should have_many(:va_secretary_priorities) }
    it { should have_many(:video_files) }
    it { should have_many(:practice_emails) }
    it { should have_many(:practice_editors) }
  end

  describe 'counter_cache' do
    before do
      user = User.create!(
        email: 'mugurama.kensei@va.gov',
        password: 'Password123',
        password_confirmation: 'Password123',
      )
      @practice = Practice.create!(
        name: 'A public practice',
        slug: 'a-public-practice',
        main_display_image: File.new(File.join(Rails.root, '/spec/assets/charmander.png')),
        user: user
      )
      visn_1 = create(:visn)
      @fac_1 = VaFacility.create!(
        visn: visn_1,
        station_number: "402GA",
        official_station_name: "Caribou VA Clinic",
        common_name: "Caribou",
        latitude: "44.2802701",
        longitude: "-69.70413586",
        street_address_state: "ME",
        station_phone_number: "207-623-2123 x",
        fy17_parent_station_complexity_level: "1c-High Complexity"
      )
    end

    it "increments counter cache on create" do
      expect {
        @practice.diffusion_histories.create!(practice: @practice, va_facility: @fac_1)
      }.to change { @practice.reload.diffusion_histories_count }.by(1)
    end

    it "decrements counter cache on destroy" do
      diffusion_history = @practice.diffusion_histories.create!(practice: @practice, va_facility: @fac_1)
      expect {
        diffusion_history.destroy
      }.to change { @practice.reload.diffusion_histories_count }.by(-1)
    end
  end

  describe 'scopes' do
    describe '.get_by_created_crh' do
      let!(:clinical_resource_hub_1) { create(:clinical_resource_hub) }
      let!(:clinical_resource_hub_2) { create(:clinical_resource_hub) }
      
      let!(:practice1) { create(:practice, published: true, enabled: true, approved: true, hidden: false) }
      let!(:practice2) { create(:practice, published: true, enabled: true, approved: true, hidden: false) }
      let!(:practice3) { create(:practice, published: false, enabled: false, approved: false, hidden: true) }

      let!(:facility_with_hub_1) { create(:practice_origin_facility, practice: practice1, clinical_resource_hub: clinical_resource_hub_1) }
      let!(:facility_with_hub_2) { create(:practice_origin_facility, practice: practice2, clinical_resource_hub: clinical_resource_hub_2) }

      it 'returns practices that are published, enabled, approved, associated with provided clinical_resource_hub_id, and have loaded associations' do
        result = Practice.published_enabled_approved.load_associations.get_by_created_crh(clinical_resource_hub_1.id)

        expect(result).to include(practice1)
        expect(result).not_to include(practice2, practice3)
      end
    end

    describe '.get_by_adopted_crh' do
      let!(:clinical_resource_hub_1) { create(:clinical_resource_hub) }
      let!(:clinical_resource_hub_2) { create(:clinical_resource_hub) }
      
      let!(:practice1) { create(:practice, published: true, enabled: true, approved: true, hidden: false) }
      let!(:practice2) { create(:practice, published: true, enabled: true, approved: true, hidden: false) }
      let!(:practice3) { create(:practice, published: false, enabled: false, approved: false, hidden: true) } # Will be filtered out by `published_enabled_approved` scope

      let!(:diffusion_history_1) { create(:diffusion_history, practice: practice1, clinical_resource_hub: clinical_resource_hub_1) }
      let!(:diffusion_history_2) { create(:diffusion_history, practice: practice2, clinical_resource_hub: clinical_resource_hub_2) }
      

      it 'returns practices that are published, enabled, approved, adopted by the given clinical_resource_hub_id, and have loaded associations' do
        result = Practice.published_enabled_approved.load_associations.get_by_adopted_crh(clinical_resource_hub_1.id)

        expect(result).to include(practice1)
        expect(result).not_to include(practice2, practice3)
      end
    end
  end
end
