require 'rails_helper'

RSpec.describe CommunityPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:community) }
    it { should belong_to(:practice) }
  end
end
