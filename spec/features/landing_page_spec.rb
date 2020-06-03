require 'rails_helper'

describe 'The landing page', type: :feature do
  it 'should come up' do
    visit '/'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Welcome to the Diffusion Marketplace')
    expect(page).to have_content('This site is designed to help spread important and life-saving promising practices throughout the VA Healthcare System.')
  end

  it 'should have a covid-19 section' do
    visit '/'
    expect(page).to have_content('COVID-19')
    expect(page).to have_content('See more')
  end
end