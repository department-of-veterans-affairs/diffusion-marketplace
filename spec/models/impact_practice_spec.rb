require 'rails_helper'

RSpec.describe ImpactPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:impact) }
    it { should belong_to(:practice) }
  end
end
