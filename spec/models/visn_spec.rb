require 'rails_helper'

RSpec.describe Visn, type: :model do
  describe 'associations' do
    it { should have_many(:vamcs) }
    it { should have_many(:visn_liaisons) }
  end
end
