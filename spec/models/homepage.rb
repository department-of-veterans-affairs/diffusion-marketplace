require 'rails_helper'

RSpec.describe Homepage, type: :model do
  describe 'associations' do
    it { should have_many(:homepage_features) }
  end
end