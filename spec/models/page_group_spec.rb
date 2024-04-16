require 'rails_helper'

RSpec.describe PageGroup, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:pages).dependent(:destroy) }
    it { is_expected.to have_many(:editors) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'callbacks' do
    describe 'before_destroy :remove_editor_roles' do
      let!(:page_group) { create(:page_group) }
      let!(:editor) { create(:user) }
      let!(:editor_role) { editor.add_role :page_group_editor, page_group }

      it 'removes associated editor roles upon page_group destruction' do
        expect(page_group.editor_roles.exists?(id: editor_role.id)).to be true

        expect { page_group.destroy }.to change(Role, :count).by(-1)
        expect(Role.exists?(id: editor_role.id)).to be false
      end
    end
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

  describe '#remove_editor_roles' do
    let(:page_group) { create(:page_group) }
    let!(:editor1) { create(:user) }
    let!(:editor2) { create(:user) }
    let!(:editor3) { create(:user) }

    before do
      editor1.add_role(:page_group_editor, page_group)
      editor2.add_role(:page_group_editor, page_group)
      editor3.add_role(:page_group_editor, page_group)
    end

    it 'removes the specified editor roles' do
      ids_to_remove = [editor1.id, editor2.id]
      page_group.remove_editor_roles(ids_to_remove)

      expect(page_group.editors).to eq([editor3])
    end
  end
end
