require 'rails_helper'

RSpec.describe PageResourcesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:page) { create(:page) }
  let(:page_resource) { create(:page_component, :with_downloadable_file_component, page: page) }

  describe "GET #download" do
    context "when the page is published" do
      context "and is public" do
        before { page.update(is_public: true) }
        it "redirects to the attachment's presigned URL" do
          get :download, params: { page_id: page.id, id: page_resource.component_id }
          expect(response).to redirect_to(page_resource.component.attachment_s3_presigned_url)
        end
      end

      context "and is not public" do
        it "responds with unauthorized" do
          get :download, params: { page_id: page.id, id: page_resource.component_id }
          expect(flash[:warning]).to eq('You are not authorized to view this content.')
          expect(response).to redirect_to(root_path) # Adjust for your login path
        end
      end
    end

    context "when the page is not published" do
      before do
        page.update(published: nil)
      end

      context "and the user is an admin" do
        it "redirects to the attachment's presigned URL" do
          sign_in admin
          get :download, params: { page_id: page.id, id: page_resource.component_id }
          expect(response).to redirect_to(page_resource.component.attachment_s3_presigned_url)
        end
      end

      context "and the user is not an admin" do
        it "responds with unauthorized" do
          sign_in user
          get :download, params: { page_id: page.id, id: page_resource.component_id }
          expect(flash[:warning]).to eq('You are not authorized to view this content.')
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "when the page does not exist" do
      it "responds with not found" do
        get :download, params: { page_id: -1, id: page_resource.component_id }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Page not found")
      end
    end
  end
end
