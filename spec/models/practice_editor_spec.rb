require 'rails_helper'

RSpec.describe PracticeEditor, type: :model do
  describe 'associations' do
    it { should belong_to(:innovable) }
    it { should belong_to(:user) }
  end
end