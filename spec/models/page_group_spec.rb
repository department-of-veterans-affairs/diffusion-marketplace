require 'rails_helper'

RSpec.describe PageGroup, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:pages).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'friendly_id' do
    it 'generates a slug from the name' do
      page_group = create(:page_group, name: 'Unique Name')
      expect(page_group.slug).to eq('unique-name')
    end
  end

  describe '#is_community?' do
    context 'when the slug is in COMMUNITY_SLUGS' do
      it 'returns true' do
        page_group = build(:page_group, slug: PageGroup::COMMUNITY_SLUGS.first)
        expect(page_group.is_community?).to be true
      end
    end

    context 'when the slug is not in COMMUNITY_SLUGS' do
      it 'returns false' do
        page_group = build(:page_group, slug: 'non-community-slug')
        expect(page_group.is_community?).to be false
      end
    end
  end
end
