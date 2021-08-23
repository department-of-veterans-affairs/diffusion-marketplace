require 'rails_helper'

describe 'Homepage', type: :feature do
  before do
    visn_8 = Visn.create!(id: 7, name: "VA Sunshine Healthcare Network", number: 8)
    visn_9 = Visn.create!(id: 8, name: "VA MidSouth Healthcare Network", number: 9)

    VaFacility.create!(visn: visn_8, station_number: "673", official_station_name: "James A. Haley Veterans' Hospital", common_name: "Tampa-Florida", street_address_state: "FL")
    VaFacility.create!(visn: visn_9, station_number: "614", official_station_name: "Memphis VA Medical Center", common_name: "Memphis", street_address_state: "TN")

    @user = User.create!(email: 'naofumi.iwatani@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user.add_role(User::USER_ROLES[1].to_sym)
    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', published: true, approved: true, user: @user)
    PracticeOriginFacility.create!(practice: @practice, facility_type: 0, va_facility_id: 1)
    visit '/'
  end

  describe 'search section' do
    it 'should allow the user to search for practices in a number of ways' do
      expect(page).to be_accessible.according_to :wcag2a, :section508

      # search for a practice using the search field
      fill_in('dm-homepage-search-field', with: 'James A. Haley')
      find('#dm-homepage-search-button').click

      expect(page).to have_content('1 result:')
      expect(page).to have_content(@practice.name)

      visit '/'
      # search for a practice by going to the 'Explore all practices' page
      click_link('Explore all practices')
      expect(page).to have_content('Explore all practices')
      expect(page).to have_content(@practice.name)
    end
  end

  describe 'featured section' do
    it 'should display the featured practice, if there is one' do
      expect(page).to_not have_content('The Best Practice Ever!')
      expect(page).to_not have_content('Highlighted body text')

      # highlight a practice
      login_as(@user, scope: :user, run_callbacks: false)
      visit '/admin/practices'
      click_link('Highlight', href: highlight_practice_admin_practice_path(@practice))
      click_link('Edit', href: edit_admin_practice_path(@practice))

      expect(page).to have_content('HIGHLIGHTED PRACTICE TITLE')
      expect(page).to have_content('HIGHLIGHTED PRACTICE BODY')

      fill_in('Highlighted Practice Body', with: 'Highlighted body text')
      click_button('Update Practice')
      visit '/'

      expect(page).to have_content('The Best Practice Ever!')
      expect(page).to have_content('Highlighted body text')

      # visit the practice's show page
      click_link('See practice')

      expect(page).to have_content('The Best Practice Ever!')
      expect(page).to have_content('Bookmark')
      expect(page).to have_content('Share')
      expect(page).to have_content('Subscribe')
      expect(page).to have_content('Print')
    end
  end

  it "it should allow the user to visit the 'Nominate a practice' page" do
    click_link('Start nomination')

    expect(page).to have_content('Nominate a practice')
    expect(page).to have_content('If you are interested in submitting a practice to the Diffusion Marketplace, review the criteria below and apply through the link.')
  end
end