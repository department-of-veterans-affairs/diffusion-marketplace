require 'rails_helper'

RSpec.describe System::OperationalTasksController, type: :controller do
  describe 'POST #clear_signer_cache' do
    let(:secure_token) { 'correct_secure_token_value' }
    let(:cache_key) { 's3_signer' }

    before do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
      ENV['CLEAR_SIGNER_CACHE_TOKEN'] = secure_token
      Rails.cache.write(cache_key, 'cached data')
      request.headers['Authorization'] = "Bearer #{token}"
    end

    context 'with valid authorization token' do
      let(:token) { secure_token }

      it 'returns status ok and clears the cache' do
        post :clear_signer_cache
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/Cache cleared successfully/)
        expect(Rails.cache.read(cache_key)).to be_nil
      end
    end

    context 'with invalid authorization token' do
      let(:token) { 'incorrect_token' }

      it 'returns forbidden status' do
        post :clear_signer_cache
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to match(/Access Denied/)
      end
    end

    context 'without any authorization token' do
      let(:token) { nil }

      it 'returns forbidden status' do
        post :clear_signer_cache
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to match(/Access Denied/)
      end
    end
  end
end
