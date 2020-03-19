require 'rails_helper'

RSpec.describe Milestone, type: :model do
  describe 'associations' do
    it { should belong_to(:timeline) }
  end
end
