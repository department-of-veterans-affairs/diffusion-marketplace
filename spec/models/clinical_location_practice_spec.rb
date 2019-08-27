# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClinicalLocationPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
    it { should belong_to(:clinical_location) }
  end
end
