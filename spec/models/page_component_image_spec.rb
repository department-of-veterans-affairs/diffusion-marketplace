require 'rails_helper'

RSpec.describe PageComponentImage, type: :model do
  describe 'associations' do
    it { should belong_to(:page_component) }
  end

  describe 'validations' do
    before do
      @invalid_image_path = "#{Rails.root}/spec/assets/SpongeBob.txt"
      @valid_image_path = "#{Rails.root}/spec/assets/charmander.png"
      page_group = PageGroup.new
      page = Page.new(page_group: page_group)
      page_component = PageComponent.new(page: page)
      @image = PageComponentImage.new(
        page_component: page_component,
        image: File.new(@valid_image_path),
        alt_text: 'test'
      )
      @validations = TestUtils::Validations.new
    end

    context 'image' do
      it "should be valid if it is present and has a content type of 'jpg', 'jpeg', or 'png'" do
        # Invalid images
        @image.image = nil
        @validations.expect_invalid_record(@image, :image, "Image can't be blank")

        @image.image = File.new(@invalid_image_path)
        @validations.expect_invalid_record(
          @image,
          :image,
          "Image must be one of the following types: jpg, jpeg, or png"
        )
        # Valid image
        @image.image = File.new(@valid_image_path)
        @validations.expect_valid_record(@image)
      end
    end

    context 'alt_text' do
      it 'should be valid if it is present' do
        # Invalid alt text
        @image.alt_text = nil
        @validations.expect_invalid_record(@image, :alt_text, "Alt text can't be blank")

        @image.alt_text = ''
        @validations.expect_invalid_record(@image, :alt_text, "Alt text can't be blank")
        # Valid alt text
        @image.alt_text = 'Hello world'
        @validations.expect_valid_record(@image)
      end
    end

    context 'URLs' do
      it_behaves_like 'URL validators' do
        let(:record) { @image }
      end
    end
  end
end