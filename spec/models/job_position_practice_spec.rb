require 'rails_helper'

RSpec.describe JobPositionPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
    it { should belong_to(:job_position) }
  end
end
