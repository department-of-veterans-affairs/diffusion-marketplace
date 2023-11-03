require 'rails_helper'

RSpec.describe System::OperationalTasksController, type: :controller do
  describe 'POST #clear_signer_cache' do
    let(:whitelisted_ip) { '123.45.67.89' }
    let(:non_whitelisted_ip) { '98.76.54.32' }
    let(:cache_key) { 's3_signer' }

    before do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
      ENV['WHITELISTED_IPS'] = '123.45.67.89,124.77.55.67'
      request.env['REMOTE_ADDR'] = ip_address
      Rails.cache.write(cache_key, 'cached data')
    end

    context 'when called from a whitelisted IP' do
      let(:ip_address) { whitelisted_ip }
      
      context 'when cache clearance is successful' do
        it 'returns status ok' do
          post :clear_signer_cache
          expect(response).to have_http_status(:ok)
          expect(response.body).to match(/Cache cleared successfully/)
          expect(Rails.cache.read(cache_key)).to be_nil
        end
      end
    end

    context 'when called from a non-whitelisted IP' do
      let(:ip_address) { non_whitelisted_ip }

      it 'returns forbidden' do
        post :clear_signer_cache
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to match(/Access Denied/)
      end
    end
  end
end
