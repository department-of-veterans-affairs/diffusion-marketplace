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

  describe 'scopes' do
    describe '.community_pages' do
      it 'includes pages with non-nil positions' do
        included_page = create(:page, position: 1)
        excluded_page = create(:page)
        excluded_page.update!(position: nil)

        expect(Page.community_pages).to include(included_page)
        expect(Page.community_pages).not_to include(excluded_page)
      end
    end
  end

  describe '#is_community_page' do
    it 'returns true if the page has a position' do
      page = build(:page, position: 1)
      expect(page.is_community_page).to be true
    end

    it 'returns false if the page does not have a position' do
      page = build(:page, position: nil)
      expect(page.is_community_page).to be false
    end
  end

  describe '#add_or_remove_from_community_subnav' do
    context 'when the page is already in the community sub-nav' do
      it 'removes the page from the community sub-nav if it has a position' do
        page = create(:page, position: 1)
        expect { page.add_or_remove_from_community_subnav }.to change { page.position }.from(1).to(nil)
      end
    end

    context 'when the page is not in the community sub-nav' do
      it 'adds the page to the community sub-nav by setting position to -1' do
        page = create(:page)
        page.update!(position: nil)
        expect { page.add_or_remove_from_community_subnav }.to change { page.position }.from(nil).to(1)
      end
    end
  end
end
