# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PracticePartner, type: :model do
  describe 'associations' do
    it { should have_many(:practices) }
    it { should have_many(:badges) }
  end
end
