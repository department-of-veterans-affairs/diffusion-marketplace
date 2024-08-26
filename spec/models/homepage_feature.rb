require 'rails_helper'

RSpec.describe HomepageFeature, type: :model do
  describe 'associations' do
    it { should belong_to(:homepage) }
  end
end