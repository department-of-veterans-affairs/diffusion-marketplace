require 'rails_helper'

RSpec.describe PagePublicationComponent, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it 'pushed_on dates' do
      expect(PagePublicationComponent.new(title: "invalid date", published_on_day: 42)).to be_invalid
      expect(PagePublicationComponent.new(title: "invalid month", published_on_month: 13)).to be_invalid
      expect(PagePublicationComponent.new(title: "invalid year", published_on_month: 198)).to be_invalid
    end
  end

  describe 'associations' do
    it { should have_one(:page_component) }
  end
end
