require 'rails_helper'

RSpec.describe PracticePartnerPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:practice_partner) }
    it { should belong_to(:practice) }
  end
end
