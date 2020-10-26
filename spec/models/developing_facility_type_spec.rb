  require 'rails_helper'

RSpec.describe DevelopingFacilityType, type: :model do
  describe 'associations' do
    it { should have_many(:developing_facility_type_practices) }
    it { should have_many(:practices) }
  end
end
