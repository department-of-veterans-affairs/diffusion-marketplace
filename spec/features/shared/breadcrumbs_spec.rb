require 'rails_helper'

describe 'Breadcrumbs', type: :feature do
  before do
    @pp = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @img_path_1 = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Innovation Ever', user: @user, initiating_facility: 'Test facility name', initiating_facility_type: 'other', tagline: 'Test tagline', is_public: true, published: true, approved: true, enabled: true, summary: 'test innovation summary')
    @user_practice2 = Practice.create!(name: 'Another Best Innovation', user: @user, initiating_facility: 'vc_0508V', tagline: 'Test tagline 2', highlight_attachment: File.new(@img_path_1), highlight: true, highlight_body: 'highlighted innovation', is_public: true, published: true, approved: true, enabled: true)
    visn_1 = Visn.create!(name: 'VISN 1', number: 2)
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
    dh_1 = DiffusionHistory.create!(practice: @user_practice, va_facility: fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_1, status: 'Completed')
    login_as(@user, :scope => :user, :run_callbacks => false)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @user_practice)
    @page_group = PageGroup.create!(name: 'programming', description: 'Pages about programming go in this group.')
    @page_group2 = PageGroup.create!(name: 'test', description: 'Pages about tests go in this group.')
    @page = Page.create!(title: 'Test', description: 'This is a test page', slug: 'home', page_group: @page_group, published: Time.now)
    @page2 = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group2, published: Time.now)
    @page3 = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group, published: Time.now)
    visit '/'
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
  end

  describe 'Pages that should not have breadcrumbs' do
    it 'should not display breadcrumbs for the search page from the navbar button' do
      find('#dm-navbar-search-button').click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the search page when clicking "Browse all innovations"' do
      click_link('Browse all innovations')
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the search page when clicking the homepage search' do
      find('#dm-homepage-search-button').click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the about page' do
      find_all("a[href='/about']").first.click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the partners index' do
      find_all("a[href='/partners']").first.click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the diffusion map' do
      click_button('Browse by locations')
      find("a[href='/diffusion-map']").click
      expect(page).to have_css(".diffusion_map-main", visible: true)
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the nominate an innovation page' do
      find("a[href='/nominate-an-innovation']").click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the visns index' do
      click_button('Browse by locations')
      find("a[href='/visns']").click
      expect(page).to_not have_css('#breadcrumbs')
    end

    it 'should not display breadcrumbs for the facilities index' do
      click_button('Browse by locations')
      find("a[href='/facilities']").click
      expect(page).to_not have_css('#breadcrumbs')
    end
  end

  describe 'Featured innovation' do
    it 'should show breadcrumbs to the home page when a user clicks a highlighted innovation' do
      click_link('View innovation')
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Another Best Innovation')
        expect(page).to have_link(href: '/')
        expect(page).to_not have_link(href: '/innovations/another-best-innovation')
      end
    end
  end

  describe 'Innovation search' do
    it 'should show proper breadcrumbs when a user searches for a practice and then visits that practice\'s page' do
      @user_practice.update(published: true, approved: true)
      fill_in('dm-navbar-search-field', with: 'the best')
      find('#dm-navbar-search-button').click
      expect(page).to have_content('The Best')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      click_on('Go to The Best Innovation Ever')
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')
        expect(page).to have_content('The Best Innovation Ever')
        expect(page).to have_link(href: '/')
        expect(page).to_not have_link(href: '/innovations/the-best-innovation-ever')
      end

      find('a[href="/search?query=the%20best"]').click
      expect(page).to have_current_path('/search?query=the%20best')
      expect(page).to_not have_css('#breadcrumbs')
    end
  end

  describe 'Innovations partners' do
    it 'should show display breadcrumbs only for the show pages' do
      @user_practice.update(published: true, approved: true)
      find("a[href='/partners']").click
      expect(page).to be_accessible.according_to :wcag2a, :section508
      click_on('Diffusion of Excellence')
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
      find('.dm-practice-link').click
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
      find('.dm-practice-link').click
      expect(page).to have_current_path(practice_path(@user_practice))
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('VISN index')
        expect(page).to have_content('2')
        expect(page).to have_link(href: '/visns')
        expect(page).to have_link(href: '/visns/2')
      end
      find('a[href="/visns/2"]').click
      fill_in('visn-search-field', with: 'best')
      find('#visn-search-button').click
      find('.dm-practice-link').click
      expect(page).to have_css("#pr-view-introduction", visible: true)
      expect(page).to have_current_path(practice_path(@user_practice))
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('VISN index')
        expect(page).to have_content('2')
        expect(page).to have_content('The Best Innovation Ever')
        expect(page).to have_link(href: '/')
        expect(page).to have_link(href: '/visns')
        expect(page).to have_link(href: '/visns/2?query=best')
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
        expect(page).to have_content('Facility index')
        expect(page).to have_link(href: '/facilities')
      end
      find('a[href="/innovations/the-best-innovation-ever"]').click
      expect(page).to have_css("#pr-view-introduction", visible: true)
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Facility index')
        expect(page).to have_content('A first facility Test Common Name')
        expect(page).to have_content('The Best Innovation Ever')
        expect(page).to have_link(href: '/')
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
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever')
      end
    end

    it 'should only allow for one practice breadcrumb at a time in order to prevent having too many breadcrumbs at one time' do
      visit practice_path(@user_practice)

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever')
      end

      # Browse to a different practice's show page
      visit practice_path(@user_practice2)

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to_not have_content('The Best Innovation Ever')
        expect(page).to have_content('Another Best Innovation')
      end
    end

    it 'should show proper breadcrumbs in the practice editor' do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_instructions_path(@user_practice)

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever')
        expect(page).to have_content('Edit')
      end
      expect(page).to have_selector('#instructions', visible: true)
      find_all('.usa-sidenav__item')[1].click

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever')
        expect(page).to have_content('Edit')
      end
      expect(page).to have_selector('#dm-practice-nav', visible: true)
      find_all('.usa-sidenav__item')[0].click

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever')
        expect(page).to have_content('Edit')
        expect(page).to have_content('Metrics')
      end
    end
  end

  describe 'Page builder flow' do
    it 'Should only show a single breadcrumb for the landing page of a page group, if the user is on a subpage' do
      visit '/programming/test-page'
      expect(page).to have_css('#breadcrumbs', visible: true)
      expect(page).to have_css('.usa-breadcrumb__link', text: @page_group.name)
      expect(page).to have_link(href: '/programming')
    end

    it 'Should not show any breadcrumbs for a subpage that has a page group without a landing page or the landing page of a page group' do
      visit '/test/test-page'
      expect(page).to_not have_css('#breadcrumbs')
      expect(page).to_not have_css('.usa-breadcrumb__link')

      visit '/programming/home'
      expect(page).to_not have_css('#breadcrumbs')
    end
  end
end
