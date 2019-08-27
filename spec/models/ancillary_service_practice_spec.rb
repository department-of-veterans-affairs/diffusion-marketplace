# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AncillaryServicePractice, type: :model do
  describe 'associations' do
    it { should belong_to(:ancillary_service) }
    it { should belong_to(:practice) }
  end
end
