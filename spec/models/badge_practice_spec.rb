require 'rails_helper'

RSpec.describe BadgePractice, type: :model do
  describe 'associations' do
    it { should belong_to(:badge) }
    it { should belong_to(:practice) }
  end
end
