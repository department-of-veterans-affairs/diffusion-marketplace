require 'rails_helper'

RSpec.describe PracticeMetric, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
  end
end
