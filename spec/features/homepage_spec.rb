require 'rails_helper'

describe 'Homepage', type: :feature do
  before do
    visn_8 = Visn.create!(id: 7, name: "VA Sunshine Healthcare Network", number: 8)
    visn_9 = Visn.create!(id: 8, name: "VA MidSouth Healthcare Network", number: 9)

    VaFacility.create!(visn: visn_8, station_number: "673", official_station_name: "James A. Haley Veterans' Hospital", common_name: "Tampa-Florida", street_address_state: "FL")
    VaFacility.create!(visn: visn_9, station_number: "614", official_station_name: "Memphis VA Medical Center", common_name: "Memphis", street_address_state: "TN")

    @user = User.create!(email: 'naofumi.iwatani@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user.add_role(User::USER_ROLES[1].to_sym)
    Practice.create!(name: 'Project HAPPEN', slug: 'project-happen', approved: true, published: true, tagline: "HAPPEN tagline", support_network_email: 'contact-happen@happen.com', user: @user)
    @practice = Practice.create!(name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', published: true, approved: true, user: @user)
    PracticeOriginFacility.create!(practice: @practice, facility_type: 0, va_facility_id: 1)
    @featured_image = "#{Rails.root}/spec/assets/charmander.png"
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit '/'
  end

  it "it should allow the user to visit the 'About' page" do
    click_link('Learn more')

    expect(page).to have_content('About us')
    expect(page).to have_current_path(about_path)
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
      # search for a practice by going to the search page
      click_link('Browse all innovations')
      expect(page).to have_current_path(search_path)
      expect(page).to have_content('Enter a search term or use the filters to find matching innovations')
    end
  end

  describe 'featured section' do
    it 'should display the featured practice, if there is one' do
      # make sure the featured section is not present without a featured practice and completed featured fields
      expect(page).to_not have_content('The Best Practice Ever!')
      expect(page).to_not have_content('Highlighted body text')

      # feature a practice
      login_as(@user, scope: :user, run_callbacks: false)
      visit '/admin/practices'
      click_link('Feature', href: highlight_practice_admin_practice_path(@practice))
      click_link('Edit', href: edit_admin_practice_path(@practice))

      expect(page).to have_content('FEATURED INNOVATION BODY')
      expect(page).to have_content('FEATURED INNOVATION ATTACHMENT')

      fill_in('Featured Innovation Body', with: 'Highlighted body text')
      find('#practice_highlight_attachment').attach_file(@featured_image)
      click_button('Update Practice')
      visit '/'

      expect(page).to have_content(@practice.name)
      expect(page).to have_content('Highlighted body text')

      # visit the practice's show page
      click_link('View innovation')

      expect(page).to have_content(@practice.name)
      expect(page).to have_content('Bookmark')
      expect(page).to have_content('Share')
      expect(page).to have_content('Subscribe')
      expect(page).to have_content('Print')
    end
  end

  it "it should allow the user to visit the 'Nominate an innovation' page" do
    click_link('Start nomination')

    expect(page).to have_content('Nominate an innovation')
    expect(page).to have_content('VA staff and collaborators are welcome to nominate active innovations for consideration on the Diffusion Marketplace using the form below.')
  end

  it 'should allow the user to subscribe to the DM newsletter by taking them to the GovDelivery site' do
    fill_in('Your email address', with: 'vladilena.milize@test.com')
    new_window_1 = window_opened_by { click_button('Subscribe today') }
    within_window new_window_1 do
      expect(current_url).to eq('https://public.govdelivery.com/accounts/USVHA/subscribers/qualify')
    end
  end
end