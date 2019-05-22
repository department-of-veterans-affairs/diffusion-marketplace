require 'rails_helper'

describe 'The landing page', type: :feature do
  it 'should come up' do
    visit '/'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Diffusion Marketplace')
    expect(page).to have_content('Saving lives by sharing best practices')
  end
end