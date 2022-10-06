require 'rails_helper'
require 'support/test_utils/attribute_validators'

include TestUtils::AttributeValidators

RSpec.describe PageComponentImage, type: :model do
  describe 'associations' do
    it { should belong_to(:page_component) }
  end

  describe 'validations' do
    before do
      page_group = PageGroup.new
      page = Page.new(page_group: page_group)
      page_component = PageComponent.new(page: page)
      @component_image = PageComponentImage.new(
        page_component: page_component,
        image: File.new("#{Rails.root}/spec/assets/charmander.png"),
        alt_text: 'test'
      )
    end

    describe 'image' do
      context 'presence' do
        it_behaves_like 'Image presence validation' do
          let(:record) { @component_image }
          let(:image_attribute) { :image }
        end
      end

      context 'content type' do
        it_behaves_like 'Image content type validation' do
          let(:record) { @component_image }
          let(:image_attribute) { :image }
        end
      end
    end

    context 'alt_text' do
      it 'should be valid if it is present' do
        # Invalid alt text
        @component_image.alt_text = nil
        expect_invalid_record(@component_image, :alt_text, "can't be blank")

        @component_image.alt_text = ''
        expect_invalid_record(@component_image, :alt_text, "can't be blank")
        # Valid alt text
        @component_image.alt_text = 'Hello world'
        expect_valid_record(@component_image)
      end
    end

    context 'URLs' do
      it_behaves_like 'URL validators' do
        let(:record) { @component_image }
      end
    end
  end
end