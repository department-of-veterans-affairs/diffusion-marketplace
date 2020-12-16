require 'rails_helper'

describe 'Practices', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test Facility', initiating_facility_type: 'other', tagline: 'Test tagline')
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', date_initiated: Time.now())
    @enabled_practice = Practice.create!(name: 'Enabled practice', approved: true, published: true, enabled: true, date_initiated: Time.now())
    @disabled_practice = Practice.create!(name: 'Disabled practice', approved: true, published: true, enabled: false, date_initiated: Time.now())
    @highlighted_practice = Practice.create!(name: 'Highlighted practice', approved: true, published: true, enabled: true, highlight: true, highlight_body: 'Highlight body text', date_initiated: Time.now())

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
    it 'should let unauthenticated users interact with practices' do
      # Visit an individual Practice
      visit '/practices/the-best-practice-ever'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('You are not authorized to view this content.')

      @user_practice.update(approved: true, published: true)
      # Visit an individual Practice
      visit '/practices/the-best-practice-ever'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('Login to see full practice')
      click_on('Login to see full practice')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'should let authenticated users interact with the marketplace' do
      login_as(@user, :scope => :user, :run_callbacks => false)

      # Visit an individual Practice that is approved and published
      visit practice_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@practice.name)
      expect(page).to have_current_path(practice_path(@practice))

      # Visit the Marketplace
      visit '/'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@highlighted_practice.name)
      expect(page).to have_content('Find the next important or life-saving practice to adopt at your VA facility.')
      expect(page).to have_link(href: '/explore')
      expect(page).to have_content('Recommended for you')
      expect(page).to have_content('Explore practices that are relevant to your location, role, and saved searches.')
      expect(page).to have_content('COVID-19')
      expect(page).to have_content('The Diffusion Marketplace has practices that help VHA respond to COVID-19. We have assembled a group of practices for frontline staff and administrators responding to the changing medical landscape.')
      expect(page).to have_link(href: '/covid-19')
      expect(page).to have_content('Nominate a practice')
      expect(page).to have_content('If you have a practice that has been adopted at two or more locations, has been endorsed by a senior executive stakeholder, and is an active practice, click the link below to submit it to the Marketplace.')
      expect(page).to have_link(href: 'mailto:marketplace@va.gov?subject=Nominate%20a%20practice')
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
      expect(page).to have_content('Find the next important or life-saving practice to adopt at your VA facility.')
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

    it 'should display the initiating facility\'s name' do
      login_as(@user, :scope => :user, :run_callbacks => false)

      # Visit an individual Practice that is approved and published
      practice = Practice.create!(name: 'Another public practice', date_initiated: Time.now(), approved: true, published: true, initiating_facility_type: 'facility', tagline: 'Test tagline')
      PracticeOriginFacility.create!(practice: practice, facility_type: 0, facility_id: '687HA')
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
      expect(page).to_not have_link('Edit practice')
    end
  end
end
