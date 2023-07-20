require 'rails_helper'

RSpec.describe PageOneToOneImageComponent, type: :model do
  describe 'validations' do
    subject do
      image_path = File.join(Rails.root, '/spec/assets/charmander.png')
      image_file = File.new(image_path)
      described_class.new(
        text_alignment: 'Left',
        image: image_file,
        image_alt_text: 'Test Image'
      )
    end

    it 'validates text alignment' do
      subject.text_alignment = 'Middle'
      expect(subject).not_to be_valid
      expect(subject.errors[:text_alignment]).to include('Middle is not a valid text alignment')
    end

    it 'validates internal urls' do
      subject.url = '/internal_url'
      expect(subject).to be_valid(InternalUrlValidator)
    end

    it 'validates external urls' do
      subject.url = 'http://external_url.com'
      expect(subject).to be_valid(ExternalUrlValidator)
    end

    it { should validate_presence_of(:image) }

    it 'validates presence of image_alt_text if image is present' do
      expect(subject).to validate_presence_of(:image_alt_text)
    end

    it 'validates content type of image' do
      file_path = File.join(Rails.root, 'spec/assets/SpongeBob.txt')
      subject.image = File.new(file_path)

      expect(subject).not_to be_valid
      expect(subject.errors[:image]).to include('is invalid')
    end
  end
end