require 'rails_helper'

RSpec.describe PracticePartner, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
  end
end
