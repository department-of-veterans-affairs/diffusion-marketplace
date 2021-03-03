require 'rails_helper'

RSpec.describe Vamc, type: :model do
  describe 'associations' do
    it { should belong_to(:visn) }
  end
end
