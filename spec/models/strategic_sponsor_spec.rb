require 'rails_helper'

RSpec.describe StrategicSponsor, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
    it { should have_many(:badges) }
  end
end
