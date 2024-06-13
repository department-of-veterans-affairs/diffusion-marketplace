require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should belong_to(:parent_category).optional  }
    it { should have_many(:sub_categories) }
  end

  describe '.prepared_categories_for_practice_editor' do
    let!(:parent_category) { create(:category, :as_parent, :with_sub_categories) }
    let!(:community_category) { create(:category, :community, :as_parent, :with_sub_categories) }

    context 'when user is an admin' do
      before do
        allow(described_class).to receive(:get_parent_categories).and_return([parent_category, community_category])
      end

      it 'prepares categories adding special categories for non-community categories' do
        result = described_class.prepared_categories_for_practice_editor(true)

        expect(result.keys).to include(parent_category, community_category)
        expect(result[parent_category].first.name).to eq("All #{parent_category.name.downcase}")
        expect(result[parent_category].last.name).to eq('Other')
        expect(result[community_category].first.name).not_to eq("All #{community_category.name.downcase}")
        expect(result[community_category].last.name).not_to eq('Other')
      end
    end

    context 'when user is not an admin' do
      it 'handles the logic based on role correctly' do
        allow(described_class).to receive(:get_parent_categories).with(false).and_return([parent_category])
        result = described_class.prepared_categories_for_practice_editor(false)

        expect(result.keys).to contain_exactly(parent_category)
      end
    end
  end

  describe '.get_parent_categories' do
    let!(:normal_category) { create(:category, :with_sub_categories) }
    let!(:community_category) { create(:category, :community, :with_sub_categories) }
    let(:other_category) { create(:category, :is_other, :with_sub_categories) }
    let(:empty_category) { create(:category) }

    context 'when user is an admin' do
      it 'includes all categories except those marked as other' do
        expect(described_class.get_parent_categories(true)).to contain_exactly(normal_category, community_category)
      end
    end

    context 'when user is not an admin' do
      it 'excludes categories marked as other and the Communities category' do
        expect(described_class.get_parent_categories(false)).to contain_exactly(normal_category)
      end
    end
  end

  describe '.get_cached_categories_grouped_by_parent' do
    let(:parent_a) { create(:category) }
    let(:parent_b) { create(:category) }

    before do
      create_list(:category, 3, parent_category: parent_a)
      create_list(:category, 5, parent_category: parent_b)
      allow(described_class).to receive(:cached_categories).and_return(described_class.all)
    end

    it 'returns categories grouped by parent and sorted by group size in descending order' do
      result = described_class.get_cached_categories_grouped_by_parent

      expect(result.keys.first).to eq(parent_a)
      expect(result.keys.second).to eq(parent_b)
      expect(result[parent_a].size).to eq(3)
      expect(result[parent_b].size).to eq(5)
    end
  end
end
