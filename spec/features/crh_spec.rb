require 'rails_helper'
require 'spec_helper'

describe 'show page' do
  it 'should throw error if VISN number does not exist in the DB' do
    visit '/crh/50'
    expect(page).to have_content('Internal server error')
    expect(page).to have_content('We\'re sorry, something went wrong. We\'re working to fix it as soon as we can. Please check back in 30 minutes.')
  end
end