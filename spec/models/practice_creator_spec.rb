require 'rails_helper'

RSpec.describe PracticeCreator, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
    it { should belong_to(:user).optional }
  end
end
