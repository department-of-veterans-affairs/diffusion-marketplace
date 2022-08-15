require 'rails_helper'

RSpec.describe Community, type: :model do
  describe 'associations' do
    it { should have_many(:community_practices) }
    it { should have_many(:community_leaders) }
    it { should have_many(:community_faqs) }
    it { should have_many(:practices).through(:community_practices) }
    it { should have_many(:users).through(:community_leaders) }
  end
end
