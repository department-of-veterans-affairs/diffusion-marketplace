require 'rails_helper'

describe 'Breadcrumbs', type: :feature do
  before do
    @pp = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002', is_major: true)
    @img_path_1 = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Innovation Ever', user: @user, initiating_facility: 'Test facility name', initiating_facility_type: 'other', tagline: 'Test tagline', is_public: true, published: true, approved: true, enabled: true, summary: 'test innovation summary')
    @user_practice2 = Practice.create!(name: 'Another Best Innovation', user: @user, initiating_facility: 'vc_0508V', tagline: 'Test tagline 2', is_public: true, published: true, approved: true, enabled: true)
    visn_1 = Visn.create!(name: 'VISN 1', number: 1)
    fac_1 = VaFacility.create!(
      visn: visn_1,
      station_number: "421",
      official_station_name: "A Test name",
      common_name: "A first facility Test Common Name",
      fy17_parent_station_complexity_level: "1a-High Complexity",
      latitude: "44.03409934",
      longitude: "-70.70545322",
      rurality: "U",
      street_address: "1 Test Ave",
      street_address_city: "Las Vegas",
      street_address_state: "NV",
      station_phone_number: '207-623-8411',
      classification: 'Primary Care CBOC',
      street_address_zip_code: "11111",
      slug: "a-first-facility-test-common-name",
      station_number_suffix_reservation_effective_date: "05/23/1995",
      mailing_address_city: "Las Vegas"
    )
    VaFacility.create!(
      visn: visn_1,
      station_number: "434",
      official_station_name: "A Second name",
      common_name: "A second facility Test Common Name",
      fy17_parent_station_complexity_level: "1a-High Complexity",
      latitude: "44.03409934",
      longitude: "-70.70545322",
      rurality: "U",
      street_address: "2 Test St",
      street_address_city: "Sacramento",
      street_address_state: "CA",
      station_phone_number: '207-623-8411',
      classification: 'Primary Care CBOC',
      street_address_zip_code: "11111",
      slug: "a-second-facility-test-common-name",
      station_number_suffix_reservation_effective_date: "05/23/1996",
      mailing_address_city: "Sacramento"
    )
    ClinicalResourceHub.create!(visn: visn_1, official_station_name: "VISN 1 Clinical Resource Hub (Remote)")
    dh_1 = DiffusionHistory.create!(practice: @user_practice, va_facility: fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_1, status: 'Completed')
    login_as(@user, :scope => :user, :run_callbacks => false)
    PracticePartnerPractice.create!(practice_partner: @pp, innovable: @user_practice)
    visit '/'
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  describe 'Pages that should not have breadcrumbs' do
    it 'should not display breadcrumbs for the search page from the navbar button' do
      find('#dm-navbar-search-desktop-button').click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the search page when clicking the homepage search' do
      find('#dm-navbar-search-desktop-button').click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the about page' do
      find_all("a[href='/about']").first.click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the diffusion map' do
      click_button('Browse by locations')
      find("a[href='/diffusion-map']").click
      expect(page).to have_css(".diffusion_map-main", visible: true)
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the nominate an innovation page' do
      find("a[href='/nominate-an-innovation'][class='dm-footer-link margin-bottom-2']").click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the visns index' do
      visit '/visns'
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the facilities index' do
      click_button('Browse by locations')
      find("a[href='/facilities']").click
      expect(page).to_not have_css('#breadcrumbs')
    end
  end

  describe 'Innovation search' do
    it 'should show proper breadcrumbs when a user searches for a practice and then visits that practice\'s page' do
      @user_practice.update(published: true, approved: true)
      fill_in('dm-navbar-search-desktop-field', with: 'the best')
      find('#dm-navbar-search-desktop-button').click
      expect(page).to have_content('The Best')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      find("a[href='#{practice_path(@user_practice)}']").click
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_css('.fa-arrow-left')
        expect(page).to have_content('Search')
        expect(page).to have_no_content('The Best Innovation Ever')
        expect(page).to have_link(href: '/search?query=the%20best')
      end

      find('a[href="/search?query=the%20best"]').click
      expect(page).to have_current_path('/search?query=the%20best')
      expect(page).to_not have_css('#breadcrumbs')
    end
  end

  describe 'Innovations partners' do
    it 'displays breadcrumbs for show pages' do
      @user_practice.update(published: true, approved: true)
      visit(practice_partner_path(@pp))
      expect(page).to have_css("#breadcrumbs", visible: true)
      expect(page).to have_css('.dm-gradient-banner')
      within(:css, '#breadcrumbs') do
        expect(page).to have_css('.fa-arrow-left')
        expect(page).to have_content('Partners')
        expect(page).to have_link(href: '/partners')
      end
      within(:css, '.dm-breadcrumb-heading') do
        expect(page).to have_content('Diffusion of Excellence')
      end
      find('.dm-practice-link-aria-hidden').click
      expect(page).to have_current_path(practice_path(@user_practice))
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Partners')
        expect(page).to have_content('Diffusion of Excellence')
        expect(page).to have_link(href: '/partners')
        expect(page).to have_link(href: '/partners/diffusion-of-excellence')
      end
    end
  end

  describe 'Visns' do
    it 'should show breadcrumbs for visns show page' do
      click_button('Browse by locations')
      find('a[href="/visns"]').click
      find('.visn-card-link').click
      expect(page).to have_css("#breadcrumbs", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_css('.fa-arrow-left')
        expect(page).to have_content('VISN index')
        expect(page).to have_link(href: '/visns')
      end
      find('.dm-practice-link-aria-hidden').click
      expect(page).to have_current_path(practice_path(@user_practice))
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('VISN index')
        expect(page).to have_content('1')
        expect(page).to have_link(href: '/visns')
        expect(page).to have_link(href: '/visns/1')
      end
      find('a[href="/visns/1"]').click
      fill_in('visn-search-field', with: 'best')
      find('#visn-search-button').click
      find('.dm-practice-link-aria-hidden').click
      expect(page).to have_css("#pr-view-introduction", visible: true)
      expect(page).to have_current_path(practice_path(@user_practice))
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('VISN index')
        expect(page).to have_content('1')
        expect(page).to have_no_content('The Best Innovation Ever')
        expect(page).to have_link(href: '/visns')
        expect(page).to have_link(href: '/visns/1?query=best')
        expect(page).to_not have_link(href: '/innovations/the-best-innovation-ever')
      end
    end
  end

  describe 'Facilities' do
    it 'should show breadcrumbs for facilities show page' do
      click_button('Browse by locations')
      find('a[href="/facilities"]').click
      find('a[href="/facilities/a-first-facility-test-common-name"]').click
      expect(page).to have_css("#dm-va-facilities-show", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_css('.fa-arrow-left')
        expect(page).to have_content('Healthcare facility index')
        expect(page).to have_link(href: '/facilities')
      end
      find('a[href="/innovations/the-best-innovation-ever"]').click
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Healthcare facility index')
        expect(page).to have_content('A first facility Test Common Name')
        expect(page).to have_no_content('The Best Innovation Ever')
        expect(page).to have_link(href: '/facilities')
        expect(page).to have_link(href: '/facilities/a-first-facility-test-common-name')
        expect(page).to_not have_link(href: '/innovations/the-best-innovation-ever')
      end
    end
  end

  describe 'Innovations' do
    it 'should show proper breadcrumbs when a user visits a practice\'s "next steps"' do
      @user_practice.update(published: true, approved: true)
      visit practice_path(@user_practice)

      within(:css, '#breadcrumbs') do
        expect(page).to have_css('.fa-arrow-left')
        expect(page).to have_content('Home')
        expect(page).to have_no_content('The Best Innovation Ever')
      end
    end

    it 'should only allow for one practice breadcrumb at a time in order to prevent having too many breadcrumbs at one time' do
      visit practice_path(@user_practice)

      within(:css, '#breadcrumbs') do
        expect(page).to have_css('.fa-arrow-left')
        expect(page).to have_content('Home')
        expect(page).to have_no_content('The Best Innovation Ever')
      end

      # Browse to a different practice's show page
      visit practice_path(@user_practice2)

      within(:css, '#breadcrumbs') do
        expect(page).to have_css('.fa-arrow-left')
        expect(page).to have_content('Home')
        expect(page).to have_no_content('Best Innovation')
      end
    end
  end

  describe 'PageBuilder community' do
    before do
      @community_page_group = create(:community)
      @community_home_page = Page.create(title: 'Community homepage', description: 'This is a community home page', slug: 'home', page_group: @community_page_group, published: Time.now)
    end

    it 'does not show breadcrumbs on homepage' do
      visit '/va-immersive/home'
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'does not render breadcrumbs for allowlisted subpages' do
      @community_approved_sub_page = Page.create(title: 'Subnav approved community subpage', description: 'Subnav approved community subpage', slug: 'About', page_group: @community_page_group, published: Time.now)
      visit '/communities/va-immersive/about'
      expect(page).not_to have_css('#breadcrumbs')
    end

    it 'does not render breadcrumbs for unapproved subpages' do
      @community_unapproved_sub_page = Page.create(title: 'Community subpage', description: 'This is a community subpage', slug: 'test-page', page_group: @community_page_group, published: Time.now)
      visit '/communities/va-immersive/test-page'
      expect(page).not_to have_css('#breadcrumbs')
    end
  end

  describe 'PageBuilder non-community' do
    before do
      @page_group = PageGroup.create!(name: 'programming', description: 'Pages about programming go in this group.')
      @page_group2 = PageGroup.create!(name: 'test', description: 'Pages about tests go in this group.')
      @page = Page.create!(title: 'Test', description: 'This is a test page', slug: 'home', page_group: @page_group, published: Time.now)
      @page2 = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group2, published: Time.now)
      @page3 = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group, published: Time.now)
    end

    it 'does not show breadcrumbs on a page group homepage' do
      visit '/programming/home'
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'shows a single breadcrumb when on the subpage of a page group with a homepage' do
      visit '/programming/test-page'
      expect(page).to have_css('#breadcrumbs', visible: true)
      expect(page).to have_css('.usa-breadcrumb__link', text: 'programming')
      expect(page).to have_link(href: '/programming')
    end

    it 'does not show breadcrumbs for a subpage of page group without a homepage' do
      visit '/test/test-page'
      expect(page).to_not have_css('#breadcrumbs')
      expect(page).to_not have_css('.usa-breadcrumb__link')
    end
  end
end
