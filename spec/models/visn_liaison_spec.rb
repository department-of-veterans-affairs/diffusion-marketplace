require 'rails_helper'

RSpec.describe VisnLiaison, type: :model do
  describe 'associations' do
    it { should belong_to(:visn) }
  end
end