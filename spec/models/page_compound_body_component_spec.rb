require 'rails_helper'

RSpec.describe PageCompoundBodyComponent, type: :model do
  describe 'associations' do
    it { should have_one(:page_component) }
  end

  describe 'validations' do
    before do
      @component = PageCompoundBodyComponent.create!
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
      it "should be valid if it is a value between 0 and 10 (integer), inclusively" do
        # Invalid margin_bottoms
        @component.margin_bottom = 12
        expect_invalid_record(@component, :margin_bottom, '12 is not a valid margin_bottom size')

        @component.margin_bottom = '3'
        expect_invalid_record(@component, :margin_bottom, '3 is not a valid margin_bottom size')
        # Valid margin_bottom
        component.margin_bottom = 7
        expect_valid_record(@component)
      end
    end

    context 'margin_top' do
      it "should be valid if it is a value between 0 and 10 (integer), inclusively" do
        # Invalid margin_tops
        @component.margin_bottom = 05
        expect_invalid_record(@component, :margin_top, '05 is not a valid margin_top size')

        @component.margin_bottom = '8'
        expect_invalid_record(@component, :margin_top, '8 is not a valid margin_bottom size')
        # Valid margin_top
        component.margin_bottom = 10
        expect_valid_record(@component)
      end
    end

    context 'URLs' do
      context 'internal URLs' do
        it 'should be valid if the path exists' do
          # invalid URLs
          @component.url = '/hello-world'
          expect_invalid_record(@component, :url, 'No route matches "/hello-world"')

          @component.url = '/visns/hello-world'
          expect_invalid_record(@component, :url, 'not a valid URL')
        end
      end
    end
  end

  def expect_valid_record(record)
    expect(record).to be_valid
    expect(record.errors.messages).to be_blank
  end

  def expect_invalid_record(record, record_attribute, validation_message)
    expect(record).to_not be_valid
    expect(record.errors.messages[record_attribute]).to include(validation_message)
  end

  # has_one :page_component, as: :component, autosave: true
  #
  # validates :text_alignment, inclusion: {
  #   in: %w[Left Right],
  #   message: "%{value} is not a valid alignment"
  # }
  # validates :margin_bottom, :margin_top, inclusion: {
  #   in: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  #   message: "%{value} is not a valid %{attribute} size"
  # }
end