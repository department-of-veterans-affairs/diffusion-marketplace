# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AncillaryService, type: :model do
  describe 'associations' do
    it { should have_many(:practices).through(:ancillary_service_practices) }
  end
end
