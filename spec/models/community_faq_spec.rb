require 'rails_helper'

RSpec.describe CommunityFAQ, type: :model do
  describe 'associations' do
    it { should belong_to(:community) }
  end
end
