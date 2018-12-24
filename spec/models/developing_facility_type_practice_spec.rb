require 'rails_helper'

RSpec.describe DevelopingFacilityTypePractice, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
    it { should belong_to(:developing_facility_type) }
  end
end
