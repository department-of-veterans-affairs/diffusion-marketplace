require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe 'associations' do
    it { should have_many(:practices).through(:badge_practices) }
    it { should belong_to(:strategic_sponsor) }
  end
end
