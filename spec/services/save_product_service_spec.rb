require 'rails_helper'

RSpec.describe SaveProductService do
  let!(:category) { create(:category) }
  let!(:sub_category) { create(:category, parent_category: category) }
  let!(:product) { create(:product, :with_image, :with_multimedia, :with_va_employees) }
  let(:user) { create(:user) }

  let(:product_params) do
    {
      name: "Updated Product",
      tagline: "Updated tagline",
      description: "Updated description",
      category: { "#{sub_category.id}_resource" => { value: sub_category.id.to_s } },
      delete_main_display_image: "false"
    }
  end

  let(:multimedia_params) do
    {
      "practice_multimedia_attributes" => {
        "0" => {
          "id" => product.practice_multimedia.first.id,
          "link_url" => "https://updated.com",
          "_destroy" => "false"
        }
      }
    }
  end

  subject { described_class.new(product: product, product_params: product_params, multimedia_params: multimedia_params) }

  describe "#call" do
    context "when valid product params are provided" do
      it "successfully updates the product" do
        result = subject.call
        expect(result).to be true
        expect(product.reload.name).to eq "Updated Product"
        expect(product.tagline).to eq "Updated tagline"
      end

      it "updates the multimedia attributes" do
        subject.call
        expect(product.practice_multimedia.first.link_url).to eq "https://updated.com"
      end

      it "updates the category associations" do
        subject.call
        expect(product.categories).to include(sub_category)
      end
    end

    context "when removing the main display image" do
      before do
        product_params[:delete_main_display_image] = "true"
      end

      it "removes the image and updates the product" do
        expect(product.main_display_image.present?).to be true
        subject.call
        expect(product.reload.main_display_image.present?).to be false
      end
    end

    context "when no changes are submitted" do
      it "does not update the product and returns false" do
        service = @service_class = described_class.new(
          product: product,
          product_params: {},
          multimedia_params: {}
        )
        result = service.call
        expect(result).to be false
        expect(product.reload.name).not_to eq "Updated Product"
      end
    end

    context "when an exception is raised" do
      before do
        allow(product).to receive(:save).and_raise(StandardError, "Something went wrong")
      end

      it "returns false and adds the error message" do
        result = subject.call
        expect(result).to be false
        expect(subject.errors).to include("Something went wrong")
      end
    end
  end
end
