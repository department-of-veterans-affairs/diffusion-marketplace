require 'rails_helper'

RSpec.describe VaFacility, type: :model do
  describe 'associations' do
    it { should belong_to(:visn) }
  end
end
