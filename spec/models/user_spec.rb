require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
    it { should have_many(:practice_editors) }
  end

  describe 'Roles' do
    it 'should have one admin role' do
      user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)

      user.add_role(User::USER_ROLES[0].to_sym)

      expect(user.roles.count).to eq(1)

      user.add_role(User::USER_ROLES[0].to_sym)

      expect(user.roles.count).to eq(1)
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
    let(:emails) { ['existing@example.com', 'nonexisting@example.com'] }
    let!(:user) { create(:user, email: 'existing@example.com') }

    it "returns users with existing emails and lists non-existing emails" do
      users, non_existent_emails = User.validate_users_by_emails(emails)

      expect(users).to contain_exactly(user)
      expect(non_existent_emails).to contain_exactly('nonexisting@example.com')
    end
  end
end
