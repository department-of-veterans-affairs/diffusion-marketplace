require 'rails_helper'

RSpec.describe Timeline, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
    it { should have_many(:milestones) }
  end
end
