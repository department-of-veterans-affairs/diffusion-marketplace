require 'rails_helper'

RSpec.describe PageBlockQuoteComponent, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:citation) }
  end

  describe 'associations' do
    it { should have_one(:page_component) }
  end

  describe 'callbacks' do
    describe '#strip_p_tags_from_text' do
      let(:component) { PageBlockQuoteComponent.new(text: '<p>Quote text</p>', citation: '<p>Quote citation</p>') }

      it 'removes <p> tags from text attribute' do
        component.save
        expect(component.text).to eq('Quote text')
      end

      it 'removes <p> tags from citation attribute' do
        component.save
        expect(component.citation).to eq('Quote citation')
      end
    end
  end
end