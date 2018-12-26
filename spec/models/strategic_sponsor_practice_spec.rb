require 'rails_helper'

RSpec.describe StrategicSponsorPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:strategic_sponsor) }
    it { should belong_to(:practice) }
  end
end
