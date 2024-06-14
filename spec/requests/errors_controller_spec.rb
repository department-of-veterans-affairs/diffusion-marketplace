require 'rails_helper'

RSpec.describe ErrorsController, type: :request do
  before(:all) do # temporarily disable Puma server errors in test
    Rails.application.config.consider_all_requests_local = false
    Rails.application.config.action_dispatch.show_exceptions = true
    Rails.application.config.action_dispatch.show_detailed_exceptions = false
  end

  after do
    Rails.application.config.consider_all_requests_local = true
    Rails.application.config.action_dispatch.show_exceptions = false
    Rails.application.config.action_dispatch.show_detailed_exceptions = true
  end

  it '404 error' do
    get '/innovations/some-random-innovation-that-does-not-exist'
    expect(response).to have_http_status(:not_found)
    expect(response.body).to include('Page not found')
    expect(response.body).to include("We're sorry, we can't find the page you're looking for")
  end

  it '500 error' do
    get '/500'
    expect(response).to have_http_status(:error)
    expect(response.body).to include('Internal server error')
    expect(response.body).to include("We're sorry, something went wrong.  We're working to fix it as soon as we can.")
  end
end