require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
    it { should have_one_attached(:avatar) }
  end

  describe 'Roles' do
    it 'should have one role' do
      user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)

      user.add_role(User::USER_ROLES[1].to_sym)

      expect(user.roles.count).to eq(1)

      user.add_role(User::USER_ROLES[0].to_sym)

      expect(user.roles.count).to eq(1)
    end
  end
end
