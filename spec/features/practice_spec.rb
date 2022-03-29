require 'rails_helper'

describe 'Practices', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test Facility', initiating_facility_type: 'other', tagline: 'Test tagline')
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', date_initiated: Time.now(), user: @user2)
    @enabled_practice = Practice.create!(name: 'Enabled practice', approved: true, published: true, enabled: true, date_initiated: Time.now(), user: @user2)
    @disabled_practice = Practice.create!(name: 'Disabled practice', approved: true, published: true, enabled: false, date_initiated: Time.now(), user: @user2)
    @highlighted_practice = Practice.create!(name: 'Highlighted practice', approved: true, published: true, enabled: true, highlight: true, highlight_body: 'Highlight body text', date_initiated: Time.now(), highlight_attachment: File.new("#{Rails.root}/spec/assets/charmander.png"), user: @user2)

    visn_20 = Visn.create!(id: 15, name: "Northwest Network", number: 20)
    @facility_1 = VaFacility.create!(visn: visn_20, station_number: "687HA", official_station_name: "Yakima VA Clinic", common_name: "Yakima", street_address_state: "WA")

    @departments = [
        Department.create!(name: 'Test department 1', short_name: 'td1'),
        Department.create!(name: 'Test department 2', short_name: 'td2'),
        Department.create!(name: 'Test department 3', short_name: 'td3'),
        Department.create!(name: 'None'),
        Department.create!(name: 'All departments equally - not a search differentiator')
    ]
    @department_practices = [
        DepartmentPractice.create!(department: @departments[0], practice: @practice),
        DepartmentPractice.create!(department: @departments[1], practice: @practice),
        DepartmentPractice.create!(department: @departments[2], practice: @practice),
        DepartmentPractice.create!(department: @departments[3], practice: @practice),
        DepartmentPractice.create!(department: @departments[4], practice: @practice)
    ]
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
  end

  describe 'Authorization' do
    it 'should let unauthenticated users interact with public-facing practices' do
      # Visit an unpublished, unapproved, internal-facing practice
      visit '/innovations/the-best-practice-ever'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('You are not authorized to view this content.')

      @user_practice.update(approved: true, published: true, is_public: true)
      # Visit a published, approved, public-facing practice
      visit '/innovations/the-best-practice-ever'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('The Best Practice Ever!')
      expect(page).to have_content('Test Facility')
    end

    it 'should not let unauthenticated users interact with internal-facing practices' do
      @user_practice.update(approved: true, published: true)
      visit '/innovations/the-best-practice-ever'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content('This innovation is not available for non-VA users.')
      expect(page).to have_content('Discover VA innovations to adopt at your facility')
    end

    it 'should let authenticated users interact with the marketplace' do
      login_as(@user, :scope => :user, :run_callbacks => false)

      # Visit an individual practice that is approved and published
      visit practice_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
      expect(page).to have_current_path(practice_path(@practice))

      # Visit the Marketplace
      visit '/'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('We’re a discovery and collaboration tool that curates VA’s promising innovations, encourages their diffusion, and fosters engagement with greater healthcare communities.')
      expect(page).to have_link(href: '/about')
      expect(page).to have_content('Browse all innovations')
      expect(page).to have_content(@highlighted_practice.name)
      expect(page).to have_content('Highlight body text')
      expect(page).to have_content('View innovation')
      expect(page).to have_content('Nominate an innovation')
      expect(page).to have_content('Are you working on an innovation that’s making a difference at VA? Submit a nomination for the innovation to be included on the Diffusion Marketplace.')
      expect(page).to have_link('Start nomination', href: nominate_an_innovation_path )
    end

    it 'should let the practice owner interact with their practice if not approved or published' do
      login_as(@user, :scope => :user, :run_callbacks => false)

      # Visit user's own practice that is not approved or published
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_current_path(practice_path(@user_practice))
      expect(page).to have_content(@user_practice.name)
    end

    it 'should not let a user view the practice if the practice is not approved or published' do
      login_as(@user2, :scope => :user, :run_callbacks => false)
      # Visit a user's practice that is not approved or published
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('We’re a discovery and collaboration tool that curates VA’s promising innovations, encourages their diffusion, and fosters engagement with greater healthcare communities.')
      expect(page).to have_current_path('/')
    end

    it 'should let an approver/editor user view the practice if the practice is not approved or published' do
      login_as(@approver, :scope => :user, :run_callbacks => false)

      # Visit a user's practice that is not approved or published
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_current_path(practice_path(@user_practice))
    end

    it 'should let an admin user view the practice if the practice is not approved or published' do
      login_as(@admin, :scope => :user, :run_callbacks => false)

      # Visit a user's practice that is not approved or published
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_current_path(practice_path(@user_practice))
    end

    it 'should let a user view the practice if it is hidden but not search for it' do
      login_as(@user2, :scope => :user, :run_callbacks => false)
      hidden_practice = Practice.create!(name: 'A secret practice', approved: true, published: true, hidden: true, tagline: 'Test secret tagline', date_initiated: Time.now(), user: @user)
      visit practice_path(hidden_practice)
      expect(page).to have_content(hidden_practice.name)
      expect(page).to have_content('Hidden practice')
      fill_in('search', with: 'A secret practice')
      find("#dm-navbar-search-desktop-button").click
      expect(page).to have_selector("#search-page")
      expect(page).to have_content('There are currently no matches for your search on the Marketplace.')
    end

    it 'should display the initiating facility\'s name' do
      login_as(@user, :scope => :user, :run_callbacks => false)

      # Visit an individual Practice that is approved and published
      practice = Practice.create!(name: 'Another public practice', date_initiated: Time.now(), approved: true, published: true, initiating_facility_type: 'facility', tagline: 'Test tagline', user: @user2)
      PracticeOriginFacility.create!(practice: practice, facility_type: 0, va_facility: @facility_1)
      visit practice_path(practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(practice.name)
      expect(page).to have_content('Yakima VA Clinic')
      expect(page).to have_current_path(practice_path(practice))
    end
  end

  describe 'show page' do
    it 'should display enabled practice in metrics' do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      # Visit an individual Practice that is enabled
      visit practice_path(@enabled_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@enabled_practice.name)
      expect(page).to have_content(@enabled_practice.initiating_facility)
      expect(page).to have_current_path(practice_path(@enabled_practice))
      click_on('Bookmark')
      visit admin_dashboard_path
      click_on('Metrics')
      expect(page).to have_content('Enabled practice')
    end

    it 'should NOT display disabled practice in metrics' do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit admin_dashboard_path
      click_on('Metrics')
      expect(page).to_not have_content('Disabled practice')
    end

    it 'should display the initiating facility\'s initiating facility property if it is not found in the map' do
      login_as(@user, :scope => :user, :run_callbacks => false)
      @user_practice.update(published: true, approved: true, initiating_facility: 'Page VA Clinic')
      # Visit an individual Practice that is approved and published
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice.initiating_facility)
      expect(page).to have_current_path(practice_path(@user_practice))
    end

    it 'should display the practice departments section' do
      login_as(@user, :scope => :user, :run_callbacks => false)
      @user_practice.update(published: true, approved: true, difficulty_aggregate: 1, sustainability_aggregate: 2, number_departments: 3, it_required: true, process: 'New approach', implementation_time_estimate: '6 months', training_provider: 'Practice champion', training_test: true, need_new_license: true, training_length: '1 month')
      visit practice_path(@user_practice)

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice.initiating_facility)
      expect(page).to have_current_path(practice_path(@user_practice))
    end

    it 'should NOT show the edit practice button if the user is not an admin/approver or creater of the practice' do
      login_as(@user, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to_not have_link('Edit innovation')
    end
  end
end
