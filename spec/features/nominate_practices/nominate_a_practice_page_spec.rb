require 'rails_helper'

describe 'Nominate an innovation page', type: :feature do
  it 'should be there' do
    visit '/nominate-a-practice'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Nominate an innovation')
    expect(page).to have_content('If you are interested in submitting an innovation to the Diffusion Marketplace, review the criteria below and apply through the link.')
    expect(page).to have_content('To qualify, your innovation must be:')
    expect(page).to have_content('Adopted at two or more locations')
    expect(page).to have_content('Endorsed by a senior executive stakeholder')
    expect(page).to have_content('An active practice')
    expect(page).to have_link('Start nomination')
  end
end
