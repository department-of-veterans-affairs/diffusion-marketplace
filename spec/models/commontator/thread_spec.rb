require 'rails_helper'

RSpec.describe Commontator::Thread, type: :model do
  describe 'associations' do
    it { should belong_to(:closer).optional }
    it { should belong_to(:commontable).without_validating_presence }
    it { should have_many(:comments) }
    it { should have_many(:subscriptions) }
  end
end