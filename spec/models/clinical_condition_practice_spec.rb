require 'rails_helper'

RSpec.describe ClinicalConditionPractice, type: :model do
  describe 'associations' do
    it { should belong_to(:clinical_condition) }
    it { should belong_to(:practice) }
  end
end
