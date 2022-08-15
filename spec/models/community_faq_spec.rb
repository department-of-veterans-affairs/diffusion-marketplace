require 'rails_helper'

RSpec.describe CommunityFaq, type: :model do
  describe 'associations' do
    it { should belong_to(:community) }
  end
end
