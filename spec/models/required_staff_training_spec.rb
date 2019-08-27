# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequiredStaffTraining, type: :model do
  describe 'associations' do
    it { should belong_to(:practice) }
  end
end
