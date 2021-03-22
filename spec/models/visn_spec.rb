require 'rails_helper'

RSpec.describe Visn, type: :model do
  describe 'associations' do
    it { should have_many(:va_facilities) }
  end
end
