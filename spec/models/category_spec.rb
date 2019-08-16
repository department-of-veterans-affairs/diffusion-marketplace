require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should belong_to(:parent_category).optional  }
    it { should have_many(:sub_impact_categories) }
  end
end
