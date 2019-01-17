require 'rails_helper'

RSpec.describe Cost, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
  end
end
