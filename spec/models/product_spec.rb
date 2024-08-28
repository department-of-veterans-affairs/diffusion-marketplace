require 'rails_helper'

RSpec.describe Product, type: :model do
  # Association tests
  it { should belong_to(:user).optional }
  it { should have_many(:category_practices).dependent(:destroy) }
  it { should have_many(:categories).through(:category_practices) }
  # it { should have_many(:practice_multimedia).order(id: :asc).dependent(:destroy) }
  # it { should have_many(:va_employee_practices).dependent(:destroy) }
  # it { should have_many(:va_employees).through(:va_employee_practices).order(position: :asc) }

  describe 'polymorphic association' do
    it 'can be associated with category practices as an innovable' do
      product = create(:product)
      category_practice = create(:category_practice, innovable: product)
      expect(product.category_practices).to include(category_practice)
    end
  end

  # # Validation tests
  # it { should validate_presence_of(:title) }
  # it { should validate_presence_of(:tagline) }

  # # Attachment tests
  # it { should have_attached_file(:main_display_image) }
  # it { should validate_attachment_content_type(:main_display_image).
  #               allowing('image/png', 'image/gif', 'image/jpg', 'image/jpeg').
  #               rejecting('text/plain', 'text/xml') }

  # # Paperclip attachment existence
  # describe 'main_display_image attachment' do
  #   it 'is valid with a valid image' do
  #     product = build(:product)
  #     product.main_display_image = File.new("#{Rails.root}/spec/support/assets/test_image.jpg")
  #     expect(product).to be_valid
  #   end

  #   it 'is invalid with a non-image file' do
  #     product = build(:product)
  #     product.main_display_image = File.new("#{Rails.root}/spec/support/assets/test.txt")
  #     expect(product).not_to be_valid
  #   end
  # end
end