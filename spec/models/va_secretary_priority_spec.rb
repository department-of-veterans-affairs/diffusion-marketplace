require 'rails_helper'

RSpec.describe VaSecretaryPriority, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
  end
end
