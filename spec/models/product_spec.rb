require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should have_many(:category_practices).dependent(:destroy) }
    it { should have_many(:categories).through(:category_practices) }
    it { should have_many(:practice_multimedia).order(id: :asc).dependent(:destroy) }
    it { should have_many(:va_employee_practices).dependent(:destroy) }
    it { should have_many(:va_employees).through(:va_employee_practices).order(position: :asc) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:name).with_message('Product name already exists') }
  end

  describe 'attachments' do
    describe 'main_display_image' do
      it 'has an attached file' do
        product = create(:product, :with_image)
        expect(product.main_display_image).to be_an_instance_of(Paperclip::Attachment)
      end

      it 'validates content type' do
        product = build(:product, :with_image)
        expect(product).to be_valid

        product.main_display_image_content_type = 'text/plain'
        expect(product).not_to be_valid
        expect(product.errors[:main_display_image_content_type]).to include('is invalid')
      end

      it 'validates presence of main_display_image_alt_text' do
          product = build(:product, main_display_image: File.new(Rails.root.join('app/assets/images/jumbotron-img.jpg')))
          expect(product).not_to be_valid
          expect(product.errors[:main_display_image_alt_text]).to include("can't be blank")

          product.main_display_image_alt_text = 'Sample alt text'
          expect(product).to be_valid
        end
    end
  end
end
