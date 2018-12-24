require 'rails_helper'

RSpec.describe ImpactCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:parent_category) }
    it { should have_many(:sub_impact_categories) }
  end
end
