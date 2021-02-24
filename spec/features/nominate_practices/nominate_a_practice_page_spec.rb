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
    expect(page).to have_link('Start nomination', href: "
mailto:marketplace@va.gov?subject=Nominate%20a%20Practice&body=I%20am%20writing%20to%20nominate%20a%20practice%20for%20the%20Diffusion%20Marketplace.%0A%0AName%20of%20practice:%0AOriginating%20facility:%0APoint%20of%20contact:%0ASenior%20executive%20stakeholder%20(if%20known):%0AAdoptions%20(if%20known):")
  end
end
