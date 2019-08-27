# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RiskMitigation, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
    it { should have_many(:risks) }
    it { should have_many(:mitigations) }
  end
end
