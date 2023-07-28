require 'rails_helper'


RSpec.describe PageEventComponent, type: :model do
  let(:event) { described_class.new }

  describe 'associations' do
    it { should have_one(:page_component) }
  end

  describe 'validations' do
    it 'rejects end dates without start date' do
      event.end_date = Date.new(2023,07,28)
      expect(event).to be_invalid
    end
  end

  describe '#rendered_date' do
    it 'renders events with only a start date' do
      event.start_date = Date.new(2023,05,16)
      expect(event.rendered_date).to eq "May 16, 2023"
    end

    it 'renders dates in different months in the same year' do
      event.start_date = Date.new(2023,05,16)
      event.end_date = Date.new(2023,06,01)
      expect(event.rendered_date).to eq "May 16 - June 1, 2023"
    end

    it 'renders events with a date range in the same year' do
      event.start_date = Date.new(2023,05,16)
      event.end_date = Date.new(2023,05,20)
      expect(event.rendered_date).to eq "May 16 - 20, 2023"
    end

    it 'renders events with a date range in different years' do
      event.start_date = Date.new(2023,05,16)
      event.end_date = Date.new(2024,01,01)
      expect(event.rendered_date).to eq "May 16, 2023 - January 1, 2024"
    end
  end
end
