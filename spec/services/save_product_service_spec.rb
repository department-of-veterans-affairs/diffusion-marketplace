require 'rails_helper'

RSpec.describe SaveProductService do
  subject(:service) { described_class.new(product: product, product_params: product_params, multimedia_params: multimedia_params) }

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


  describe "#call" do
    context "when valid product params are provided" do
      it "successfully updates the product" do
        service.call

        expect(product.reload.name).to eq "Updated Product"
        expect(product.tagline).to eq "Updated tagline"
      end

      it "updates the multimedia attributes" do
        service.call
        expect(product.practice_multimedia.first.link_url).to eq "https://updated.com"
      end

      it "updates the category associations" do
        service.call
        expect(product.categories).to include(sub_category)
      end
    end

    context "when removing the main display image" do
      before do
        product_params[:delete_main_display_image] = "true"
      end

      it "removes the image and updates the product" do
        expect(product.main_display_image.present?).to be true
        service.call
        expect(product.reload.main_display_image.present?).to be false
      end
    end

    context "when adding an editor" do
      let(:product_params) { { add_editor: user.email } }

      before do
        allow(PracticeEditorMailer).to receive_message_chain(:invite_to_edit, :deliver)
      end

      it "successfully adds an editor" do
        expect { service.call }.to change { product.practice_editors.count }.by(1)
        expect(product.practice_editors.last.user).to eq(user)
        expect(PracticeEditorMailer).to have_received(:invite_to_edit).with(product, instance_of(User)).once
      end

      it "does not add a duplicate editor" do
        product.practice_editors.create(user: user, email: user.email)

        expect { service.call }.not_to(change { product.practice_editors.count })
        expect(service.errors).to include("A user with the email \"#{user.email}\" is already an editor for this product")
      end

      it "fails when no matching user exists" do
        non_existent_email = "nonexistent@va.gov"
        updated_product_params = product_params.merge(add_editor: non_existent_email)
        service_with_invalid_email = described_class.new(
          product: product,
          product_params: updated_product_params,
          multimedia_params: {}
        )

        service_with_invalid_email.call
        product.reload

        expect(product.practice_editors).not_to include(non_existent_email)
        expect(service_with_invalid_email.errors).to include("No user found with the email \"#{non_existent_email}\"")
      end
    end

    context "when removing an editor" do
      let!(:practice_editor) { product.practice_editors.create(user: user, email: user.email) }
      let!(:user2) { create(:user) }
      let!(:practice_editor2) { product.practice_editors.create(user: user2, email: user2.email) }
      let(:product_params) { { delete_editor: practice_editor.id } }

      it "successfully removes the specified editor and retains the other editor" do
        service.call

        expect(product.practice_editors.reload).not_to include(practice_editor)
        expect(product.practice_editors).to include(practice_editor2)
      end

      it "fails when the editor does not exist" do
        invalid_params = { delete_editor: 999 }
        service_with_invalid_id = described_class.new(product: product, product_params: invalid_params, multimedia_params: {})
        service_with_invalid_id.call
        expect(service_with_invalid_id.errors).to include("User is not an editor for this practice")
      end
    end

    context "when no changes are submitted" do
      it "does not update the product and returns false" do
        service = @service_class = described_class.new(
          product: product,
          product_params: {},
          multimedia_params: {}
        )
        service.call
        expect(product.reload.name).not_to eq "Updated Product"
      end
    end

    context "when an exception is raised during save" do
      let(:product_params) { { name: nil } }
      let(:multimedia_params) { {} }

      it "returns false and adds the error message" do
        service.call

        expect(service.errors).to include("Name can't be blank")
      end
    end
  end
end
