# spec/models/page_news_component_spec.rb
require 'rails_helper'

RSpec.describe PageNewsComponent, type: :model do
  let(:valid_image_path) { Rails.root.join('spec/assets/charmander.png') }
  let(:invalid_image_path) { Rails.root.join('spec/assets/SpongeBob.txt') } # Assuming this is a text file

  context 'with image attached' do
    let(:component) { PageNewsComponent.new(image: File.new(valid_image_path), image_alt_text: "Test Image") }

    it 'is valid' do
      expect(component).to be_valid
    end

    it 'validates content type of image' do
      component.image = File.new(invalid_image_path)
      expect(component).not_to be_valid
      expect(component.errors.full_messages).to include('Image content type is invalid')
    end

    it 'validates presence of image alt text' do
      component.image_alt_text = nil
      expect(component).not_to be_valid
      expect(component.errors.full_messages).to include("Image alt text can't be blank")
    end
  end

  context 'without image attached' do
    let(:component) { PageNewsComponent.new }

    it 'is valid' do
      expect(component).to be_valid
    end

    it 'does not validate presence of image alt text' do
      component.image_alt_text = nil
      expect(component).to be_valid
    end
  end
end
