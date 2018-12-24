require 'rails_helper'

RSpec.describe Impact, type: :model do
  describe 'associations' do
    it { should have_many(:impact_practices) }
    it { should have_many(:practices) }
    it { should belong_to(:impact_category) }
  end
end
