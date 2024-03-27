require 'rails_helper'


RSpec.describe PageEventComponent, type: :model do
  let(:event) { described_class.new }
  let(:today) { Date.current }

  describe 'associations' do
    it { should have_one(:page_component) }
  end

  describe 'validations' do
    it 'rejects end dates without start date' do
      event.end_date = Date.new(2023,07,28)
      expect(event).to be_invalid
    end

    it 'allows events to have no start_date or end_date' do
      event.start_date = nil
      event.end_date = nil
      expect(event).to be_valid
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

  describe '.passed_and_hidden' do
    it 'returns true if end_date has passed and flagged to hide' do
      event = create(:page_event_component, start_date: today - 5.days, end_date: today - 2.days, hide_once_passed: true)
      expect(event.passed_and_hidden).to eq(true)
    end

    it 'returns true if there is no end_date and start_date has passed and flagged to hide' do
      event = create(:page_event_component, start_date: today - 5.days, end_date: nil, hide_once_passed: true)
      expect(event.passed_and_hidden).to eq(true)
    end

    it 'returns false if end_date has passed but not flagged to hide' do
      event = create(:page_event_component, start_date: today - 5.days, end_date: nil, hide_once_passed: false)
      expect(event.passed_and_hidden).to eq(false)
    end

    it 'returns false if no end_date or start_date and flagged to hide' do
      event = create(:page_event_component, start_date: today - 5.days, end_date: today - 2.days, hide_once_passed: true)
      expect(event.passed_and_hidden).to eq(true)
    end
  end
end
