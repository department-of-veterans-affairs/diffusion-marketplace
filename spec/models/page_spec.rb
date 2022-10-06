require 'rails_helper'
require 'support/test_utils/attribute_validators'

include TestUtils::AttributeValidators

RSpec.describe Page, type: :model do
  before do
    page_group = PageGroup.new
    @page = Page.new(
      page_group: page_group,
      title: 'Cool new page',
      slug: 'COOL-NEW-PAGE',
      description: 'Test description',
      image_alt_text: 'test'
    )
  end

  describe 'associations' do
    it { should belong_to(:page_group) }
    it { should have_many(:page_components) }
  end

  describe 'validations' do
    describe 'image' do
      context 'content type' do
        it_behaves_like 'Image content type validation' do
          let(:record) { @page }
          let(:image_attribute) { :image }
        end
      end
    end

    describe 'image_alt_text' do
      it 'should not save an image if alt text is not also present' do
        @page.image_alt_text = nil
        @page.image = File.new("#{Rails.root}/spec/assets/charmander.png")
        expect_invalid_record(
        @page,
          :image_alt_text,
          "can't be blank if Page image is present"
        )
      end
    end
  end

  describe 'downcase_slug' do
    context 'if a slug is present' do
      it 'should downcase the slug' do
        expect(@page.send(:downcase_slug)).to eq('cool-new-page')
      end
    end

    context 'if a slug is not present' do
      it 'should return nil' do
        @page.slug = nil
        expect(@page.send(:downcase_slug)).to eq(nil)
      end
    end
  end
end
