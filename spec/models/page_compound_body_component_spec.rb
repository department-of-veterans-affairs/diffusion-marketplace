require 'rails_helper'
require 'support/utils/validations'

include TestUtils::Validations

RSpec.describe PageCompoundBodyComponent, type: :model do
  describe 'associations' do
    it { should have_one(:page_component) }
  end

  describe 'validations' do
    before do
      @component = PageCompoundBodyComponent.new
    end

    context 'text_alignment' do
      it "should be valid if it is a value equal to 'Left' or 'Right'" do
        # Invalid
        @component.text_alignment = 'center'
        expect_invalid_record(@component, :text_alignment, 'center is not a valid text alignment')
        # Valid
        @component.text_alignment = 'Right'
        expect_valid_record(@component)
      end
    end

    context 'margin_bottom' do
      it 'should be valid if it is a value between 0 and 10 (rails type casts, so strings work as well), inclusively' do
        # Invalid margin_bottoms
        @component.margin_bottom = 12
        expect_invalid_record(@component, :margin_bottom, '12 is not a valid Margin bottom size')

        @component.margin_bottom = -4
        expect_invalid_record(@component, :margin_bottom, '-4 is not a valid Margin bottom size')
        # Valid margin_bottom
        @component.margin_bottom = 7
        expect_valid_record(@component)
      end
    end

    context 'margin_top' do
      it 'should be valid if it is a value between 0 and 10 (rails type casts, so strings work as well), inclusively' do
        # Invalid margin_tops
        @component.margin_top = -1
        expect_invalid_record(@component, :margin_top, '-1 is not a valid Margin top size')

        @component.margin_top = 11
        expect_invalid_record(@component, :margin_top, '11 is not a valid Margin top size')
        # Valid margin_top
        @component.margin_top = 10
        expect_valid_record(@component)
      end
    end

    context 'URLs' do
      it_behaves_like 'URL validators' do
        let(:record) { @component }
      end
    end
  end
end