# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should belong_to(:practice) }
  end
end
