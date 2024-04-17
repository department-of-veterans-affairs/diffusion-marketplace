require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
    it { should have_many(:practice_editors) }
  end

  describe 'Roles' do
    it 'should have one role' do
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
end
