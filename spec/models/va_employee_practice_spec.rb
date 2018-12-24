require 'rails_helper'

RSpec.describe VaEmployeePractice, type: :model do
  describe 'associations' do
    it { should belong_to(:va_employee) }
    it { should belong_to(:practice) }
  end
end
