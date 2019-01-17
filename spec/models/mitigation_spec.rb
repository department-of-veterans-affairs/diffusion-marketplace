require 'rails_helper'

RSpec.describe Mitigation, type: :model do
  describe 'associations' do
    it { should belong_to(:risk_mitigation) }
  end
end
