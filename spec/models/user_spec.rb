require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
    it { should have_many(:practice_editors) }
  end

  describe 'Roles' do
    let(:user) { create(:user) }
    let!(:admin_role) { user.add_role(User::USER_ROLES[0].to_sym) }
    let!(:pg_a) { create(:page_group) }
    let!(:pg_b) { create(:page_group) }
    let!(:editor_role_a) { user.add_role(:page_group_editor, pg_a) }
    let!(:editor_role_b) { user.add_role(:page_group_editor, pg_b) }

    it 'can have multiple unique page_group_editor roles and one admin role' do
      expect(user.roles.count).to eq(3)
      expect(user.roles).to include(admin_role, editor_role_a, editor_role_b)
    end

    it 'will not duplicate an editor role' do
      expect(user.add_role(User::USER_ROLES[0].to_sym)).to eq(admin_role)
      expect(user.roles.count).to eq(3)
      expect(user.roles).to include(admin_role, editor_role_a, editor_role_b)

      expect(user.add_role(:page_group_editor, pg_a)).to eq(editor_role_a)
      expect(user.roles.count).to eq(3)
      expect(user.roles).to include(admin_role, editor_role_a, editor_role_b)
    end
  end

  describe '#editable_page_group_ids' do
    let(:user) { create(:user) }
    let(:page_group_a) { create(:page_group) }
    let(:page_group_b) { create(:page_group) }
    let(:page_group_c) { create(:page_group) }

    before do
      user.add_role(:page_group_editor, page_group_a)
      user.add_role(:page_group_editor, page_group_b)
    end

    it 'returns only ids of page groups where the user is a page group editor' do
      expect(user.editable_page_group_ids).to contain_exactly(page_group_a.id, page_group_b.id)
    end
  end

  describe ".validate_users_by_emails" do
    let(:emails) { ['existing@va.gov', 'nonexisting@va.gov', 'CaseInsensitive@va.gov'] }
    let!(:user) { create(:user, email: 'existing@va.gov') }
    let!(:case_insensitive_user) { create(:user, email: 'caseinsensitive@va.gov') }

    it "returns users with existing emails and lists non-existing emails" do
      users, non_existent_emails = User.validate_users_by_emails(emails)

      expect(users).to contain_exactly(user, case_insensitive_user)
      expect(non_existent_emails).to contain_exactly('nonexisting@va.gov')
    end
  end

  describe '#preferred_full_name' do
    context 'when both alt_first_name and alt_last_name are present' do
      it 'returns the full name using the alt names' do
        user = User.new(alt_first_name: 'Jay', alt_last_name: 'Smith', first_name: 'James', last_name: 'Doe')
        expect(user.preferred_full_name).to eq('Jay Smith')
      end
    end

    context 'when only alt_first_name is present' do
      it 'returns the full name using alt_first_name and last_name' do
        user = User.new(alt_first_name: 'Jay', first_name: 'James', last_name: 'Doe')
        expect(user.preferred_full_name).to eq('Jay Doe')
      end
    end

    context 'when only alt_last_name is present' do
      it 'returns the full name using first_name and alt_last_name' do
        user = User.new(first_name: 'James', alt_last_name: 'Smith')
        expect(user.preferred_full_name).to eq('James Smith')
      end
    end

    context 'when neither alt names nor primary names are present' do
      it 'returns "User"' do
        user = User.new
        expect(user.preferred_full_name).to eq('User')
      end
    end

    context 'when only first_name and last_name are present' do
      it 'returns the full name using first_name and last_name' do
        user = User.new(first_name: 'James', last_name: 'Doe')
        expect(user.preferred_full_name).to eq('James Doe')
      end
    end
  end

  describe '#bio_page_name' do
    context 'when accolades are present' do
      it 'returns the preferred full name with accolades' do
        user = User.new(alt_first_name: 'Jay', last_name: 'Doe', accolades: 'Ph.D.')
        expect(user.bio_page_name).to eq('Jay Doe, Ph.D.')
      end
    end

    context 'when accolades are not present' do
      it 'returns only the preferred full name' do
        user = User.new(first_name: 'James', last_name: 'Doe')
        expect(user.bio_page_name).to eq('James Doe')
      end
    end

    context 'when preferred full name returns "User"' do
      it 'returns "User" without accolades' do
        user = User.new(accolades: 'Ph.D.')
        expect(user.bio_page_name).to eq('User, Ph.D.')
      end
    end
  end
end
