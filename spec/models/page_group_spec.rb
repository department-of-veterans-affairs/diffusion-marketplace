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
    describe 'before_destroy :remove_all_editor_roles' do
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

  describe 'scopes' do
    describe '.accessible_by' do
      let(:admin) { create(:user) }
      let(:editor) { create(:user) }
      let(:page_group_a) { create(:page_group) }
      let(:page_group_b) { create(:page_group) }
      let(:page_group_c) { create(:page_group) }

      before do
        admin.add_role(:admin)
        editor.add_role(:page_group_editor, page_group_b)
      end

      context 'when the user is an admin' do
        it 'returns all page groups' do
          expect(described_class.accessible_by(admin)).to contain_exactly(page_group_a, page_group_b, page_group_c)
        end
      end

      context 'when the user is a page group editor' do
        it 'returns only accessible page groups' do
          expect(described_class.accessible_by(editor)).to contain_exactly(page_group_b)
        end
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
