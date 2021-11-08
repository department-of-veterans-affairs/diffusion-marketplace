require 'rails_helper'

describe 'Breadcrumbs', type: :feature do
  before do
    @pp = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Innovation Ever!', user: @user, initiating_facility: 'Test facility name', initiating_facility_type: 'other', tagline: 'Test tagline')
    @user_practice2 = Practice.create!(name: 'Another Best Innovation', user: @user, initiating_facility: 'vc_0508V', tagline: 'Test tagline 2')
    login_as(@user, :scope => :user, :run_callbacks => false)
    PracticePartnerPractice.create!(practice_partner: @pp, practice: @user_practice)
    @page_group = PageGroup.create!(name: 'programming', description: 'Pages about programming go in this group.')
    @page_group2 = PageGroup.create!(name: 'test', description: 'Pages about tests go in this group.')
    @page = Page.create!(title: 'Test', description: 'This is a test page', slug: 'home', page_group: @page_group, published: Time.now)
    @page2 = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group2, published: Time.now)
    @page3 = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group, published: Time.now)
  end

  describe 'Practice partners flow' do
    it 'should show Practice partners' do
      @user_practice.update(published: true, approved: true)
      visit '/partners'
      expect(page).to be_accessible.according_to :wcag2a, :section508

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Partners')
      end
      click_on('Diffusion of Excellence')
      sleep 0.1
      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Partners')
        expect(page).to have_content('Diffusion of Excellence')
      end

      find('.dm-practice-link').click
      expect(page).to have_current_path(practice_path(@user_practice))

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Partners')
        expect(page).to have_content('Diffusion of Excellence')
        expect(page).to have_content('The Best Innovation Ever!')
      end
    end
  end

  describe 'Practices flow' do
    it 'should show proper breadcrumbs when a user visits a practice\'s "next steps"' do
      @user_practice.update(published: true, approved: true)
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever!')
      end
    end

    it 'should only allow for one practice breadcrumb at a time in order to prevent having too many breadcrumbs at one time' do
      visit practice_path(@user_practice)

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever!')
      end

      # Browse to a different practice's show page
      visit practice_path(@user_practice2)

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to_not have_content('The Best Innovation Ever!')
        expect(page).to have_content('Another Best Innovation')
      end
    end

    it 'should show proper breadcrumbs in the practice editor' do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_instructions_path(@user_practice)

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever!')
        expect(page).to have_content('Edit')
      end
      expect(page).to have_selector('#instructions', visible: true)
      find_all('.usa-sidenav__item')[1].click

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever!')
        expect(page).to have_content('Edit')
      end
      expect(page).to have_selector('#dm-practice-nav', visible: true)
      find_all('.usa-sidenav__item')[0].click

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('The Best Innovation Ever!')
        expect(page).to have_content('Edit')
        expect(page).to have_content('Metrics')
      end
    end
  end

  describe 'Practice Search flow' do
    it 'should show proper breadcrumbs when a user searches for a practice and then visits that practice\'s page' do
      @user_practice.update(published: true, approved: true)
      visit '/'
      fill_in('dm-navbar-search-field', with: 'the best')
      find('#dm-navbar-search-button').click
      expect(page).to have_content('The Best')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')
      end
      click_on('Go to The Best Innovation Ever!')
      # TODO: why is this timing out?
      # expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')
        expect(page).to have_content('The Best Innovation Ever!')
      end

      # go back to search page
      fill_in('dm-navbar-search-field', with: 'the best')
      find('#dm-navbar-search-button').click
      expect(page).to have_current_path('/search?query=the%20best')

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')

        # go back to homepage
        click_on('Home')
      end
      expect(page).to have_current_path('/')
    end

    it 'should add a search breadcrumb with no query if the user visits a practice page via the url bar(does not click on the practice\'s card)' do
      @user_practice.update(published: true, approved: true)
      visit '/'
      fill_in('dm-navbar-search-field', with: 'the best')
      find('#dm-navbar-search-button').click

      expect(page).to have_content('The Best')
      expect(page).to be_accessible.according_to :wcag2a, :section508
      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')
      end

      # Visit a practice's page from the url bar
      visit practice_path(@user_practice2)

      within(:css, '#breadcrumbs') do
        expect(page).to have_content('Home')
        expect(page).to have_content('Search')
        # go back to search
        click_on('Search')
      end
      expect(page).to have_current_path('/search')
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
      expect(page).to have_css('#breadcrumbs', visible: false)
      expect(page).to_not have_css('.usa-breadcrumb__link')

      visit '/programming/home'
      expect(page).to have_css('#breadcrumbs', visible: false)
    end
  end
end