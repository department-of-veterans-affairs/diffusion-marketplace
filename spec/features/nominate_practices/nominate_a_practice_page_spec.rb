require 'rails_helper'

describe 'Nominate a practice page', type: :feature do
  it 'should be there' do
    visit '/nominate-a-practice'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Nominate a practice')
    expect(page).to have_content('If you are interested in submitting a practice to the Diffusion Marketplace, review the criteria below and apply through the link.')
    expect(page).to have_content('To qualify, your practice must be:')
    expect(page).to have_content('Adopted at two or more locations')
    expect(page).to have_content('Endorsed by a senior executive stakeholder')
    expect(page).to have_content('An active practice')
    expect(page).to have_link('Start nomination')
  end
end
