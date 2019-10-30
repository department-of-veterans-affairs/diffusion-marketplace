require 'rails_helper'

describe 'Practices', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline')
    @departments = [
        Department.create!(name: 'Admissions', short_name: 'admissions'),
        Department.create!(name: 'None', short_name: 'none'),
        Department.create!(name: 'All departments equally - not a search differentiator', short_name: 'all'),
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

      # Visit the Marketplace
      visit '/'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content('The Best Practice Ever!')
      expect(page).to have_current_path('/')
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
      expect(page).to have_content(@practice.name)
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
      expect(page).to have_content('This site is designed to help spread important and life-saving promising practices throughout the VA Healthcare System.')
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
      practice = Practice.create!(name: 'A public practice', approved: true, published: true, initiating_facility: 'vc_0508V', tagline: 'Test tagline')
      visit practice_path(practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(practice.name)
      expect(page).to have_content('Tacoma Vet Center')
      expect(page).to have_current_path(practice_path(practice))

      # Visit the Marketplace
      visit '/practices'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(practice.name)
      expect(page).to have_content('Tacoma Vet Center')
    end
  end

  describe 'show page' do
    it 'should display the initiating facility\'s initiating facility property if it is not found in the map' do
      login_as(@user, :scope => :user, :run_callbacks => false)
      @user_practice.update(published: true, approved: true)
      # Visit an individual Practice that is approved and published
      visit practice_path(@user_practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice.initiating_facility)
      expect(page).to have_current_path(practice_path(@user_practice))

      # Visit the Marketplace
      visit '/practices'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice.initiating_facility)
    end

    it 'should display the practice complexity section' do
      login_as(@user, :scope => :user, :run_callbacks => false)
      @user_practice.update(published: true, approved: true, difficulty_aggregate: 1, sustainability_aggregate: 2, number_departments: 3, it_required: true, process: 'New approach', implementation_time_estimate: '6 months', training_provider: 'Practice champion', training_test: true, need_new_license: true, training_length: '1 month')
      AdditionalStaff.create!(title: 'Nurse', hours_per_week: '10', duration_in_weeks: '7', practice: @user_practice)
      AdditionalStaff.create!(title: 'Doctor', hours_per_week: '30', duration_in_weeks: '12', practice: @user_practice)
      visit practice_path(@user_practice)

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_content(@user_practice.name)
      expect(page).to have_content(@user_practice.initiating_facility)
      expect(page).to have_current_path(practice_path(@user_practice))
      expect(page).to have_content('Significant complexity to implement')
      expect(page).to have_content('Implementation
Little or no complexity')
      expect(page).to have_content('Maintenance and sustainability
Some complexity')
      expect(page).to have_content('Departments required
Three departments')
      expect(page).to have_content('IT Involvement
Yes')
      expect(page).to have_content('Job titles required
Nurse, Doctor')
      expect(page).to have_content('Hours per week
40 hours per week')
      expect(page).to have_content('Duration of job
19 weeks')
      expect(page).to have_content('New or modified approach
New approach')
      expect(page).to have_content('Expected length of implementation
6 months')
      expect(page).to have_content('Length of training
1 month')
      expect(page).to have_content('Training provider
Practice champion')
      expect(page).to have_content('Required test
Yes')
      expect(page).to have_content('Required license or certification
Yes')
    end

  end

  describe 'Next Steps' do
    describe 'flow' do
      it 'should not let the user go to the "Next Steps" page if the Practice is not approved/published' do
        visit practice_planning_checklist_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content('You need to sign in or sign up before continuing.')
        expect(page).to have_current_path('/users/sign_in')
      end

      it 'should lead the user to the "Next Steps" page' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        @user_practice.update(published: true, approved: true)
        # Visit an individual Practice that is approved and published
        visit practice_path(@user_practice)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content(@user_practice.name)
        expect(page).to have_content(@user_practice.initiating_facility)
        expect(page).to have_current_path(practice_path(@user_practice))

        # click on next steps link in sticky nav section
        find(:css, '#next-steps-link-in-nav').click

        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content(@user_practice.name)
        expect(page).to have_content(@user_practice.initiating_facility)
        expect(page).to have_current_path(practice_planning_checklist_path(practice_id: @user_practice.slug))
      end
    end

    describe 'checklist' do
      it 'should have a list of certain items' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        @user_practice.update(published: true, approved: true)
        # Visit an individual Practice that is approved and published
        visit practice_planning_checklist_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content(@user_practice.name)
        expect(page).to have_content(@user_practice.initiating_facility)
        expect(page).to have_current_path(practice_planning_checklist_path(@user_practice))

        # implementation team checkbox
        expect(page).to have_selector('#implementation-team')
        find(:css, 'label[for="team"]').set(true)
        expect(page).to have_content('You can’t do this alone! A team is needed to get it done. Here are the departments and titles of specific individuals that are needed to work together to implement the practice successfully. Ideal team size is 5 to 10 members.')

        # practice champion checkbox
        expect(page).to have_selector('#practice-champion')
        find(:css, 'label[for="practice-champion-input"]').click
        expect(page).to have_content('Working Group needs to select a dynamic, charismatic individual who will be able to promote the practice, recruit additional team members, and illicit administrative support.')

        # feedback checkbox
        expect(page).to have_selector('#feedback-section')
        find(:css, 'label[for="feedback-section-input"]').click
        expect(page).to have_content('Feedback on the implementation process and sharing the resulting data once the practice is implemented are a requirement/expected.')

        expect(page).not_to have_selector('#permissions-required')
        expect(page).not_to have_selector('#it-department')
        expect(page).not_to have_selector('#departments-impacted')
        expect(page).not_to have_selector('#resource-capabilities')
        expect(page).not_to have_selector('#costs-list')

        # Add the rest of the checkboxes

        as = AdditionalStaff.create!(title: 'ACOS of Mental Health', practice: @user_practice)
        pp = PracticePermission.create!(description: 'Licensing', practice: @user_practice)
        @user_practice.update(it_required: true)
        dp = DepartmentPractice.create!(department: @departments[0], practice: @user_practice)
        ar = AdditionalResource.create!(description: 'Access to Government Car for IPS Specialist', practice: @user_practice)
        c = Cost.create!(description: 'IPS Supervision and Fidelity Monitoring (Toscano) Travel costs.', practice: @user_practice)

        visit practice_planning_checklist_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content(@user_practice.name)
        expect(page).to have_content(@user_practice.initiating_facility)
        expect(page).to have_current_path(practice_planning_checklist_path(@user_practice))

        expect(page).to have_selector('#permissions-required')
        expect(page).to have_selector('#it-department')
        expect(page).to have_selector('#departments-impacted')
        expect(page).to have_selector('#resource-capabilities')
        expect(page).to have_selector('#costs-list')

        expect(page).to have_content(as.title)
        expect(page).to have_content(pp.description)
        expect(page).to have_content('Information technology department required')
        expect(page).to have_content(dp.department.name)
        expect(page).to have_content(ar.description)
        expect(page).to have_content(c.description)

        find(:css, "label[for='additional-staff-#{as.id}']").click
        find(:css, 'label[for="permissions-required-input"]').click
        find(:css, 'label[for="it-department-input"]').click
        find(:css, 'label[for="departments-impacted-input"]').click
        find(:css, 'label[for="resource-capabilities-input"]').click
        find(:css, 'label[for="costs-list-input"]').click
      end

      it 'should not render departments if all or none are selected' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        @user_practice.update(published: true, approved: true)

        # none
        dp = DepartmentPractice.create!(department: @departments[1], practice: @user_practice)

        visit practice_planning_checklist_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content(@user_practice.name)
        expect(page).to have_content(@user_practice.initiating_facility)
        expect(page).to have_current_path(practice_planning_checklist_path(@user_practice))

        expect(page).not_to have_selector('#departments-impacted')

        # all
        dp = DepartmentPractice.create!(department: @departments[2], practice: @user_practice)

        visit practice_planning_checklist_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content(@user_practice.name)
        expect(page).to have_content(@user_practice.initiating_facility)
        expect(page).to have_current_path(practice_planning_checklist_path(@user_practice))

        expect(page).not_to have_selector('#departments-impacted')
      end
    end

    describe 'adopt to practice' do
      it 'should let a user adopt a practice' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        @user_practice.update(published: true, approved: true, support_network_email: 'test@va.gov')
        # Visit an individual Practice that is approved and published
        visit practice_planning_checklist_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content(@user_practice.name)
        expect(page).to have_content(@user_practice.initiating_facility)
        expect(page).to have_current_path(practice_planning_checklist_path(@user_practice))

        click_on('Adopt this practice')
        expect(page).to have_current_path(practice_committed_path(@user_practice))
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content('Thank you!')
        expect(page).to have_content('A member of the practice support team will follow up with you shortly.')
      end

      it 'should not let a user commit to a practice' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        @user_practice.update(published: true, approved: true, support_network_email: 'test@va.gov')
        # Visit an individual Practice that is approved and published
        visit practice_committed_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content('You must commit to this practice first!')
      end

      it 'should let the user know they already committed to a practice' do
        login_as(@user, :scope => :user, :run_callbacks => false)
        @user_practice.update(published: true, approved: true, support_network_email: 'test@va.gov')
        UserPractice.create!(user: @user, practice: @user_practice, committed: true)
        # Visit an individual Practice that is approved and published
        visit practice_planning_checklist_path(practice_id: @user_practice.slug)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        click_on('Adopt this practice')
        expect(page).to have_current_path(practice_committed_path(@user_practice))
        expect(page).to have_content("You have already committed to this practice. If you did not receive a follow-up email from the practice support team yet, please contact them at #{@user_practice.support_network_email}")
      end
    end
  end

  ########## Practice Edit ############
  describe 'Practice Edit' do
    describe 'practice edit authorization' do
      it 'should not let a non-admin user edit a practice' do
        login_as(@user2, :scope => :user, :run_callbacks => false)
        @user_practice.update(approved: true, published: true)
        visit practice_path(@user_practice)
        expect(page).to have_no_link('Edit')

        visit edit_practice_path(@user_practice)
        expect(page).to have_current_path(root_path)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_content('You are not authorized to view this content.')
      end

      it 'should let an editor user edit a practice' do
        login_as(@approver, :scope => :user, :run_callbacks => false)
        @user_practice.update(approved: true, published: true)
        visit practice_path(@user_practice)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_link('Edit')
      end

      it 'should let an admin user edit a practice' do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        @user_practice.update(approved: true, published: true)
        visit practice_path(@user_practice)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        expect(page).to have_link('Edit')
      end
    end

    describe 'editing a practice' do
      it 'should update the practice' do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        @user_practice.update(approved: true, published: true)
        visit practice_path(@user_practice)
        expect(page).to have_link('Edit')
        click_link('Edit')
        fill_in 'Descriptive Title for Practice', with: 'The Coolest Practice Ever!'
        execute_script("$('.practice-form-submit').click()")

        expect(page).to have_current_path(practice_path(@user_practice))
        expect(page).to have_content('The Coolest Practice Ever!')
      end

      it 'should add a practice_parter to the practice', js: true do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        @practice.update(approved: true, published: true)
        # Practice should have no practice_partners
        expect(@practice.practice_partners.count).to eq(0)
        visit practice_path(@practice)
        expect(page).to have_link('Edit')
        click_link('Edit')

        expect(page).to have_current_path(edit_practice_path(@practice))
        execute_script("$('body').scrollTo($('h2:contains(Practice Partners)'))")
        execute_script("$('#practice_partner_1').click()")
        click_link('SAVE ALL CHANGES')

        expect(page).to have_current_path(practice_path(@practice))
        # Practice should have now have 1 practice_partner
        expect(@practice.practice_partners.count).to eq(1)
      end

      it 'should add a department to the practice', js: true do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        @user_practice.update(approved: true, published: true)
        # Practice should have no departments
        expect(@user_practice.departments.count).to eq(0)
        visit practice_path(@user_practice)
        expect(page).to have_link('Edit')
        click_link('Edit')

        execute_script("$('body').scrollTo($('h2:contains(Departments affected)'))")
        execute_script("$('#practice_department_1').click()")
        click_link('SAVE ALL CHANGES')

        expect(page).to have_current_path(practice_path(@user_practice))
        # Practice should have now have 1 department
        expect(@user_practice.departments.count).to eq(1)
      end
    end

    describe 'highlight and featured practices' do
      it 'should highlight and un-highlight a practice' do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        @user_practice.update(approved: true, published: true)
        visit practice_path(@user_practice)
        expect(page).to have_link('Edit')
        click_link('Edit')

        page.accept_confirm do
          click_link('HIGHLIGHT')
        end
        expect(page).to have_current_path(edit_practice_path(@user_practice))
        expect(page).to have_content('REMOVE HIGHLIGHT')
  
        visit(edit_practice_path(@user_practice))
        page.accept_confirm do
          click_link('REMOVE HIGHLIGHT')
        end
        expect(page).to have_current_path(edit_practice_path(@user_practice))
        expect(page).to have_content('HIGHLIGHT')
        expect(page).to have_content('HIGHLIGHT')
      end

      it 'should feature and un-feature a practice' do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        @user_practice.update(approved: true, published: true)
        visit practice_path(@user_practice)
        expect(page).to have_link('Edit')
        click_link('Edit')

        click_link('FEATURE')
        expect(page).to have_current_path(edit_practice_path(@user_practice))
        expect(page).to have_content('REMOVE FEATURE')
        expect(page).to have_content('HIGHLIGHT')

        visit root_path
        within '.featured-practices' do
          expect(page).to have_content('The Best Practice Ever!')
        end

        visit(edit_practice_path(@user_practice))

        click_link('REMOVE FEATURE')
        expect(page).to have_current_path(edit_practice_path(@user_practice))
        expect(page).to have_content('FEATURE')
        expect(page).to have_content('HIGHLIGHT')
      end
    end
  end
end
