require 'rails_helper'

RSpec.describe VaSecretaryPriorityPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:va_secretary_priority) }
    it { should belong_to(:practice) }
  end
end
