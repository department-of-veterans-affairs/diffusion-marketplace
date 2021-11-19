require 'rails_helper'

describe 'custom 404 error page', type: :feature do
=begin
  manipulate the Rails configs so that we can see custom error pages whilst in the development AND testing environment. Set them back to their original values after the tests have been ran
=end
  before do
    Rails.application.config.consider_all_requests_local = false
    Rails.application.config.action_dispatch.show_exceptions = true
  end

  after do
    Rails.application.config.consider_all_requests_local = true
    Rails.application.config.action_dispatch.show_exceptions = false
  end

  it 'should respond with the custom 404 page if the user visits a non-existent page' do
    visit '/innovations/some-random-innovation-that-does-not-exist'
    expect(page).to have_content('Page not found')
    expect(page).to have_content('We\'re sorry, we can\'t find the page you\'re looking for. It might have been removed, changed names, or is otherwise unavailable.')
  end
end