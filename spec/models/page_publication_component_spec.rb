require 'rails_helper'

RSpec.describe PagePublicationComponent, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'associations' do
    it { should have_one(:page_component) }
  end
end
