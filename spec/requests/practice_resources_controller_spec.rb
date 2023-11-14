require 'rails_helper'

RSpec.describe PracticeResourcesController, type: :controller do
  describe 'GET #download' do
    let(:practice_resource) { create(:practice_resource) } # Assumes a PracticeResource factory is defined

    context 'when accessing the download action' do
      it 'redirects to a URL that includes the attachment path' do
        get :download, params: { practice_id: practice_resource.practice.id, id: practice_resource.id }

        expect(response).to redirect_to(/\/system\/practice_resources\/attachments\/.*\/original\/dummy.pdf\?.*/)
      end

      it 'returns a 404 status if the practice is not found' do
        get :download, params: { practice_id: 'nonexistent', id: practice_resource.id }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a 404 status if the resource is not found' do
        get :download, params: { practice_id: practice_resource.practice.id, id: 'nonexistent' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
