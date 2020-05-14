require 'rails_helper'

describe 'Nominate a practice page', type: :feature do
  it 'should be there' do
    visit '/nominate-a-practice'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Practice Criteria')
    expect(page).to have_content('Be adopted at 2 or more locations')
    expect(page).to have_content('Endorsed by senior executive stakeholder')
    expect(page).to have_content('nomination criteria?')
    expect(page).to have_selector(:css, 'a[href="mailto:marketplace@va.gov?subject=Nominate%20a%20Practice"]')
  end
end
