# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PracticeManagement, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
  end
end
