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
    context 'when the name is in COMMUNITIES' do
      it 'returns true' do
        page_group = create(:page_group, name: PageGroup::COMMUNITIES.first)
        expect(page_group.is_community?).to be true
      end
    end

    context 'when the slug is not in COMMUNITIES' do
      it 'returns false' do
        page_group = create(:page_group, name: 'non-public-slug')
        expect(page_group.is_community?).to be false
      end
    end
  end

  describe '.public_with_home_hash' do
    let!(:public_page_group) { create(:page_group, name: "VA Immersive") }
    let!(:non_public_page_group) { create(:page_group, name: "Suicide Prevention") }

    let!(:public_page) { create(:page, page_group: public_page_group, slug: "home", is_public: true, published: Date.today) }
    let!(:private_page) { create(:page, page_group: non_public_page_group, slug: "home", is_public: false, published: Date.today) }

    context 'when public is true' do
      it 'returns hash of public communities with "home" pages' do
        result = PageGroup.community_with_home_hash(true, false)
        expect(result.keys).to include(public_page_group.name)
        expect(result.values).to include(public_page_group.slug)
        expect(result.keys).not_to include(non_public_page_group.name)
      end
    end

    context 'when public is false' do
      it 'returns hash with public and non-public community names and page slugs' do
        result = described_class.community_with_home_hash(false, false)
        expect(result.keys).to include(public_page_group.name)
        expect(result.values).to include(public_page_group.slug)
        expect(result.keys).to include(non_public_page_group.name)
        expect(result.values).to include(non_public_page_group.slug)
      end
    end

    context 'when admin is true' do
      it 'includes admin preview for unpublished home pages' do
        admin_only_page_group = create(:page_group, name: "Age-Friendly")
        create(:page, page_group: admin_only_page_group, slug: "home", is_public: false, published: nil)
        result = described_class.community_with_home_hash(false, true)
        expect(result.keys).to include(public_page_group.name)
        expect(result.values).to include(public_page_group.slug)
        expect(result.keys).to include(non_public_page_group.name)
        expect(result.values).to include(non_public_page_group.slug)
        expect(result.keys).to include("#{admin_only_page_group.name} - Admin Preview")
        expect(result.values).to include(admin_only_page_group.slug)
      end
    end
  end
end
