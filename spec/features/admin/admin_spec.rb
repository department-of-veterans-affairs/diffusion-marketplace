# frozen_string_literal: true

# User admin specs
require 'rails_helper'

describe 'The admin dashboard', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', first_name: 'Spongebob', last_name: 'Squarepants', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user2 = User.create!(email: 'patrick.star@va.gov', first_name: 'Patrick', last_name: 'Star', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123',
                             password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)

    visn_8 = Visn.create!(id: 7, name: "VA Sunshine Healthcare Network", number: 8)
    @facility_1 = VaFacility.create!(visn: visn_8, station_number: "516", official_station_name: "C.W. Bill Young Department of Veterans Affairs Medical Center", common_name: "Bay Pines", street_address_state: "FL")

    @practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline', published: true, approved: true, retired: false)
    @practice_2 = Practice.create!(name: 'The Second Best Innovation Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline', published: true, approved: true, retired: false)
    @categories = [
      Category.create!(name: 'COVID', description: 'COVID related practices', related_terms: ['COVID-19, Coronavirus']),
      Category.create!(name: 'Telehealth', description: 'Telelhealth related practices')
    ]
    CategoryPractice.create(practice_id: @practice[:id], category_id: @categories[1][:id])
    @departments = [
      Department.create!(name: 'Admissions', short_name: 'admissions'),
      Department.create!(name: 'None', short_name: 'none'),
      Department.create!(name: 'All departments equally - not a search differentiator', short_name: 'all'),
    ]
    @practice_partner = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative', icon: 'fas fa-heart', color: '#E4A002')
    @featured_image = "#{Rails.root}/spec/assets/charmander.png"
  end

  after(:all) do
    # remove .xlsx file download
    FileUtils.rm_rf("#{Rails.root}/tmp/downloads")
  end

  def create_diffusion_history
    diffusion_history = DiffusionHistory.create!(practice_id: @practice.id, va_facility: @facility_1)
    DiffusionHistoryStatus.create!(diffusion_history_id: diffusion_history.id, status: 'Completed')
  end

  def visit_practice_show
    visit '/admin/practices'
    within_table('index_table_practices') do
      within ".even" do
        first('.table_actions').click_link('View')
      end
    end
  end

  it 'if not logged in, should be redirected to sign_in page' do
    visit '/admin'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_current_path(new_user_session_path)
  end

  it 'if logged in as a non-admin, should be redirected to landing page' do
    login_as(@user, scope: :user, run_callbacks: false)
    visit '/admin'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Unauthorized access!')
  end

  it 'should show the admin dashboard if logged in as an admin' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_current_path(admin_root_path)

    expect(page).to have_selector('#users-information', visible: true)
    expect(page).to have_selector('#innovation-leaderboards', visible: false)
    expect(page).to have_selector('#general-practice-search-terms-table', visible: false)

    within(:css, '.tabs.ui-tabs') do
      click_link('Innovation Leaderboards')
      expect(page).to have_selector('#users-information', visible: false)
      expect(page).to have_selector('#innovation-leaderboards', visible: true)
      expect(page).to have_selector('#general-practice-search-terms-table', visible: false)
      expect(page).to have_css("input[value='Export as .xlsx']", visible: false)

      click_link('Innovation Search Terms')
      expect(page).to have_selector('#users-information', visible: false)
      expect(page).to have_selector('#innovation-leaderboards', visible: false)
      expect(page).to have_selector('#general-practice-search-terms-table', visible: true)
      expect(page).to have_css("input[value='Export as .xlsx']", visible: false)

      click_link('Users Information')
      expect(page).to have_selector('#users-information', visible: true)
      expect(page).to have_selector('#innovation-leaderboards', visible: false)
      expect(page).to have_selector('#general-practice-search-terms-table', visible: false)
      expect(page).to have_css("input[value='Export as .xlsx']", visible: false)

      click_link('Metrics')
      expect(page).to have_selector('#users-information', visible: false)
      expect(page).to have_selector('#innovation-leaderboards', visible: false)
      expect(page).to have_selector('#general-practice-search-terms-table', visible: false)
      expect(page).to have_css("input[value='Export as .xlsx']", visible: true)
    end
  end

  it 'should show allow admin to download metrics as .xlsx file' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Metrics')
    export_button = find(:css, "input[type='submit']")
    export_button.click

    # should not navigate away from metrics page
    expect(page).to have_current_path(admin_root_path)
  end

  it 'should have several tabs that allow navigation' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_current_path(admin_root_path)

    within(:css, '#header') do
      click_link('Dashboard')
      expect(page).to have_current_path(admin_dashboard_path)

      click_link('Categories')
      expect(page).to have_current_path(admin_categories_path)

      click_link('Comments')
      expect(page).to have_current_path(admin_comments_path)

      click_link('Departments')
      expect(page).to have_current_path(admin_departments_path)

      click_link('Practice Partners')
      expect(page).to have_current_path(admin_practice_partners_path)

      click_link('Practices')
      expect(page).to have_current_path(admin_practices_path)

      click_link('Users')
      expect(page).to have_current_path(admin_users_path)

      click_link('Versions')
      expect(page).to have_current_path(admin_versions_path)
    end
  end

  it 'should be able to view, add, edit, and delete categories' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    # view categories
    click_link('Categories')
    expect(page).to have_current_path(admin_categories_path)
    expect(page).to have_content('COVID')
    expect(page).to have_content('COVID-19, Coronavirus')
    expect(page).to have_content('Telehealth')

    # new category
    click_link('New Category')
    expect(page).to have_current_path(new_admin_category_path)
    fill_in('Name', with: 'Mental Health')
    fill_in('Description', with: 'Mental Health related practices')
    fill_in('Related Terms', with: 'emotional health, emotional wellbeing')
    click_button('Create Category')
    expect(page).to have_current_path(admin_category_path(Category.last))

    # edit category
    click_link('Edit Category')
    fill_in('Related Terms', with: 'psychological health, mental wellbeing')
    click_button('Update Category')
    expect(page).to have_current_path(admin_category_path(Category.last))
    expect(page).to have_content('psychological health, mental wellbeing')

    # edit category - remove related terms
    click_link('Edit Category')
    fill_in('Related Terms', with: '')
    click_button('Update Category')
    expect(page).to have_current_path(admin_category_path(Category.last))
    expect(page).to have_no_content('psychological health, mental wellbeing')

    # delete category
    visit '/admin/categories'
    expect(page).to have_content('COVID')
    expect(page).to have_content('Telehealth')
    expect(page).to have_content('Mental Health')
    find("a[href='/admin/categories/#{@categories[0][:id]}']", class: 'delete_link').click
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_no_content('COVID')
  end

  it 'should be able to view and update departments' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Departments')
    expect(page).to have_current_path(admin_departments_path)

    click_link('New Department')
    expect(page).to have_current_path(new_admin_department_path)
    fill_in('Name', with: 'Test Department')
    fill_in('Short name', with: 'Test')
    fill_in('Description', with: 'This is a test department for test purposes.')
    click_button('Create Department')
    expect(page).to have_current_path(admin_department_path(Department.last))
    click_link('Edit Department')
    fill_in('Name', with: 'Revised Department')
    click_button('Update Department')
    expect(page).to have_current_path(admin_department_path(Department.last))
    expect(page).to have_content('Revised Department')
  end

  it 'should be able to view and update Practice partner' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Practice Partners')
    expect(page).to have_current_path(admin_practice_partners_path)

    click_link('New Practice Partner')
    expect(page).to have_current_path(new_admin_practice_partner_path)
    fill_in('Name', with: 'Test Practice Partner')
    fill_in('Short name', with: 'Test')
    fill_in('Description', with: 'This is a test practice partner for test purposes.')
    click_button('Create Practice partner')
    expect(page).to have_current_path(admin_practice_partner_path(PracticePartner.last))
    click_link('Edit Practice Partner')
    fill_in('Name', with: 'Revised Practice Partner')
    click_button('Update Practice partner')
    expect(page).to have_current_path(admin_practice_partner_path(PracticePartner.last))
    expect(page).to have_content('Revised Practice Partner')
  end

  it 'should be able to view Practices and redirect to practice editor' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    within(:css, '#header') do
      click_link('Practices')
      expect(page).to have_current_path(admin_practices_path)
    end

    within_table('index_table_practices') do
      within ".even" do
        first('.table_actions').click_link('View')
      end
    end
    expect(page).to have_current_path(admin_practice_path(@practice))
  end

  it 'should be able to view, create, and update Users' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    within(:css, '#header') do
      click_link('Users')
      expect(page).to have_current_path(admin_users_path)
    end

    click_link('New User')
    expect(page).to have_current_path(new_admin_user_path)
    fill_in('Email', with: 'Test@va.gov')
    fill_in('user_password', with: 'Pass#123')
    fill_in('user_password_confirmation', with: 'Pass#123')
    click_button('Create User')
    expect(page).to have_current_path(admin_user_path(User.last))

    click_link('Edit User')
    execute_script("document.getElementById('user_role_ids_1').checked = true;")
    click_button('Update User')
    expect(page).to have_current_path(admin_user_path(User.last))
    expect(page).to have_content('admin')
  end

  it 'should be able to view Versions and revert' do
    @practice.update_attributes(name: 'This is a new Version!')
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Versions')
    expect(page).to have_current_path(admin_versions_path)

    within_table('index_table_versions') do
      first('.table_actions').click_link('View')
    end
    expect(page).to have_current_path(admin_version_path(Version.last))

    page.accept_confirm do
      click_link('Revert to this version')
    end
    expect(page).to have_current_path(admin_version_path(Version.last))
  end

  it 'should be able to create a new Practice and browse to the Practice' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Practices')
    expect(page).to have_current_path(admin_practices_path)

    click_link('New Practice')
    expect(page).to have_current_path(new_admin_practice_path)

    expect(page).to have_no_content('Highlighted Innovation Title')
    expect(page).to have_no_content('Highlighted Innovation Body')

    # add extra whitespace to practice name
    fill_in('Innovation name', with: ' The Newest Practice   ')
    fill_in('User email', with: 'practice_owner@va.gov')
    click_button('Create Practice')
    # make sure white space is trimmed from practice name
    expect(Practice.last.name).to eq('The Newest Practice')
    expect(page).to have_current_path(admin_practice_path(Practice.last))
    expect(page).to have_content(User.last.email)
    click_link("#{practice_overview_path(Practice.last)}")

    expect(page).to have_current_path(practice_overview_path(Practice.last))
  end

  it 'should not allow an admin to create a new practice if they do not enter the required information' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Practices')
    click_link('New Practice')

    fill_in('Innovation name', with: 'The Newest Practice')
    click_button('Create Practice')
    # check for blank email
    expect(page).to have_content('There was an error. Email cannot be blank.')
    expect(page).to_not have_selector("input[value='The Newest Practice']")
    # check for invalid email
    fill_in('Innovation name', with: 'The Newest Practice')
    fill_in('User email', with: 'practice_owner@test.com')
    click_button('Create Practice')

    expect(page).to have_content('There was an error. Email must be a valid @va.gov address.')
    expect(page).to_not have_selector("input[value='The Newest Practice']")
    expect(page).to_not have_selector("input[value='practice_owner@test.com']")

    # check for blank practice name
    fill_in('User email', with: 'practice_owner@test.com')
    click_button('Create Practice')

    expect(page).to have_content('There was an error. Innovation name cannot be blank.')
    expect(page).to_not have_selector("input[value='practice_owner@test.com']")
  end

  it 'should allow an admin to update the name of a practice as long as the updated name does not already belong to an existing practice' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Practices')
    click_link('Edit', href: edit_admin_practice_path(@practice))
    fill_in('Innovation name', with: @practice_2.name)
    click_button('Update Practice')

    expect(page).to have_content('There was an error. Innovation name already exists.')
    expect(page).to have_selector("input[value='The Best Practice Ever!']")

    # add extra whitespace to practice name
    fill_in('Innovation name', with: '       Test Practice 1 ')
    click_button('Update Practice')

    expect(page).to have_content('Innovation was successfully updated.')
    expect(page).to have_content('Test Practice 1')
    # make sure white space is trimmed from practice name
    click_link('Edit Practice')
    expect(page).to have_field('Innovation name', with: 'Test Practice 1')
  end

  it 'should not allow an admin to update an existing practice if they do not enter the required information' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Practices')
    click_link('Edit', href: edit_admin_practice_path(@practice))
    # check for blank practice name
    fill_in('Innovation name', with: '')
    click_button('Update Practice')

    expect(page).to have_content('There was an error. Innovation name cannot be blank.')
    expect(page).to have_selector("input[value='The Best Practice Ever!']")

    # check for blank email
    fill_in('Innovation name', with: 'Test Practice')
    fill_in('practice_user_id', with: '')
    click_button('Update Practice')

    expect(page).to have_content('There was an error. Email cannot be blank.')
    expect(page).to have_selector("input[value='spongebob.squarepants@va.gov']")

    # check for invalid email
    fill_in('User email', with: 'practice_owner@test.com')
    click_button('Update Practice')

    expect(page).to have_content('There was an error. Email must be a valid @va.gov address.')
    expect(page).to have_selector("input[value='spongebob.squarepants@va.gov']")
  end

  it 'should send an email for a newly assigned practice owner as long as the user is not already an editor for the practice' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'

    click_link('Practices')
    click_link('Edit', href: edit_admin_practice_path(@practice))
    fill_in('User email', with: 'test@va.gov')
    # make sure the mailer count increases by 1
    expect { click_button('Update Practice') }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(page).to have_content('Innovation was successfully updated.')
    # make sure the mailer subject is for a practice owner that is now also a practice editor
    expect(ActionMailer::Base.deliveries.last.subject).to eq('You have been added to the list of practice editors for the The Best Practice Ever! Diffusion Marketplace Page!')

    visit practice_editors_path(@practice)
    expect(page).to have_content('test@va.gov')

    visit '/admin'

    click_link('Practices')
    click_link('Edit', href: edit_admin_practice_path(@practice))
    fill_in('User email', with: @user.email)

    # make sure the mailer count does not increase by 1
    expect { click_button('Update Practice') }.to_not change { ActionMailer::Base.deliveries.count }
  end

  it 'practice owner emails are downloaded when user clicks csv link and get_practice_owner_emails scope specified' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
    click_link('Practices')
    expect(page).to have_current_path(admin_practices_path)
    click_link 'Get Practice Owner Emails'
    expect(page).to have_current_path('/admin/practices?scope=get_practice_owner_emails')
    expect(page).to have_content('Displaying all 2 Practices')
  end

  it 'should be able to view existing and add categories to a Practice' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
    click_link('Practices')
    expect(page).to have_content('Last Updated')
    expect(page).to have_content('Date Published')

    # check if categories display correctly
    click_link('Edit', href: edit_admin_practice_path(@practice))
    expect(page).to have_content('Categories')
    expect(page).to have_content('Covid')
    expect(page).to have_content('Telehealth')
    expect(find_field('practice_category_ids').find('option[selected]').text).to eq('Telehealth')

    # check if categories saves correctly with new practice name
    fill_in('Innovation name', with: 'renamed practiced')
    find("option[value='#{@categories[0][:id]}']").click
    find("option[value='#{@categories[1][:id]}']").click
    click_button('Update Practice')
    click_link('Edit', href: edit_admin_practice_path(@practice))
    expect(find_field('practice_category_ids').find('option[selected]').text).to eq('Covid')

    # check if categories are deleted correctly
    find("option[value='#{@categories[0][:id]}']").click
    click_button('Update Practice')
    click_link('Edit', href: edit_admin_practice_path(@practice))
    expect(page).not_to have_selector('option[selected]')
  end

  it 'should be able to feature a practice, if one is not already featured' do
    login_as(@admin, scope: :user, run_callbacks: false)
    pr_2 = Practice.create!(name: 'Another Test Practice', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline', published: true, approved: true)
    pr_3 = Practice.create!(name: 'Another Test Practice 2', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')

    visit '/'
    expect(page).to have_no_content('Highlighted by the VA this month')
    # feature practice
    visit '/admin'
    click_link('Practices')
    expect(page).to have_content('Feature')
    click_link('Feature', href: highlight_practice_admin_practice_path(@practice))
    expect(page).to have_content("\"#{@practice.name}\" is now the featured innovation.")
    expect(find_all('.col-featured > span')[3].text).to eq 'YES'
    click_link('Feature', href: highlight_practice_admin_practice_path(pr_2))
    expect(page).to have_content("Only one innovation can be featured at a time.")
    expect(find_all('.col-featured > span')[1].text).to eq 'NO'
    click_link('Feature', href: highlight_practice_admin_practice_path(pr_3))
    expect(page).to have_content("Innovation must be published to be featured.")
    expect(find_all('.col-featured > span')[0].text).to eq 'NO'
    visit '/'
    # Should not show featured section unless featured fields have been completed
    expect(page).to_not have_content(@practice.name)
    # add featured content
    visit '/admin'
    click_link('Practices')
    click_link('Edit', href: edit_admin_practice_path(@practice))
    expect(page).to have_content('FEATURED INNOVATION BODY')
    expect(page).to have_content('FEATURED INNOVATION ATTACHMENT')
    fill_in('Featured Innovation Body', with: 'pretty cool practice')
    # practice should not update unless both featured fields are completed
    click_button('Update Practice')
    expect(page).to_not have_content('Innovation was successfully updated.')
    expect(page).to have_content('ERROR - The following required \'featured\' field was not completed: \'featured innovation attachment\'')
    fill_in('Featured Innovation Body', with: 'pretty cool practice')
    find('#practice_highlight_attachment').attach_file(@featured_image)
    click_button('Update Practice')
    expect(page).to have_content('Innovation was successfully updated.')
    visit '/'
    expect(page).to have_content(@practice.name)
    expect(page).to have_content('pretty cool practice')
    # unfeature practice
    visit '/admin'
    click_link('Practices')
    expect(page).to have_content('Unfeature')
    click_link('Unfeature', href: highlight_practice_admin_practice_path(@practice))
    expect(find_all('.col-featured > span').first.text).to eq 'NO'
    expect(page).to have_content("\"#{@practice.name}\" is no longer the featured innovation.")
    visit '/'
    expect(page).to have_no_content(@practice.name)
  end

  it 'should be able to toggle between retired and active states from actions column' do
    login_as(@admin, scope: :user, run_callbacks: false)
    pr_2 = Practice.create!(name: 'Another Test Practice', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline', published: true, approved: true, retired: false)
    # Retire practice
    visit '/admin'
    click_link('Practices')
    expect(page).to have_content('Retire')
    click_link('Retire', href: retire_practice_admin_practice_path(pr_2))
    expect(page).to have_content("\"#{pr_2.name}\" was retired")

    # Activate practice
    click_link('Activate', href: retire_practice_admin_practice_path(pr_2))
    expect(page).to have_content("\"#{pr_2.name}\" was activated")
  end

  it 'should be able to toggle between hidden and visible states from the actions column' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
    click_link('Practices')
    expect(page).to have_content('Hide')
    click_link('Hide', href: hide_practice_admin_practice_path(@practice))
    expect(page).to have_content("\"#{@practice.name}\" is hidden from search")
    click_link('Show', href: hide_practice_admin_practice_path(@practice))
    expect(page).to have_content("\"#{@practice.name}\" is no longer hidden from search")
  end


  it 'should only display a button to download adoptions if the practice has any' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
    visit_practice_show

    expect(page).to_not have_selector("input[value='Download Adoption Data']")

    create_diffusion_history
    visit_practice_show

    expect(page).to have_selector("input[value='Download Adoption Data']")
  end

  it 'should allow an admin user to download adoption data as a .xlsx file if there are any adoptions' do
    create_diffusion_history

    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
    visit_practice_show
    export_button = find(:css, "input[value='Download Adoption Data']")
    export_button.click

    # should not navigate away from metrics page
    expect(page).to have_current_path(admin_practice_path(@practice))
  end

  it 'should allow an admin to toggle the \'is_public\' attribute on or off for any given practice' do
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin/practices'

    expect(first('.col-public .status_tag')).to have_content('NO')

    first('.toggle-practice-privacy-link').click
    expect(page).to have_content("\"#{@practice_2.name}\" is now a public-facing innovation")
    expect(first('.col-public .status_tag')).to have_content('YES')

    first('.toggle-practice-privacy-link').click
    expect(page).to have_content("\"#{@practice_2.name}\" is now a VAEC internal-facing innovation")
    expect(first('.col-public .status_tag')).to have_content('NO')
  end

  # runs successfully locally but fails in CI
  # it 'if the practice user is changed, it should remove the previous practice user from the comment thread subscribers list for that practice, unless they created at least one comment on the thread' do
  #   # trigger the create_or_update_practice method in the admin controller
  #   login_as(@admin, scope: :user, run_callbacks: false)
  #   visit '/admin/practices/the-best-practice-ever/edit'
  #   click_button('Update Practice')

  #   expect(Practice.first.commontator_thread.subscribers.first).to eq(@user)

  #   # change the practice user
  #   visit '/admin/practices/the-best-practice-ever/edit'
  #   fill_in('practice_user_id', with: @user2.email)
  #   click_button('Update Practice')

  #   expect(Practice.first.commontator_thread.subscribers.first).to_not eq(@user)
  #   expect(Practice.first.commontator_thread.subscribers.first).to eq(@user2)

  #   # create a comment with the current practice user
  #   logout
  #   login_as(@user2, :scope => :user, :run_callbacks => false)
  #   visit practice_path(@practice)
  #   fill_in('comment[body]', with: 'This is a test comment')
  #   click_button('commit')

  #   # change the practice user back to the original user
  #   logout
  #   visit '/'
  #   login_as(@admin, :scope => :user, run_callbacks: false)
  #   visit '/admin/practices/the-best-practice-ever/edit'
  #   expect(page).to have_content('USER EMAIL')
  #   fill_in('practice_user_id', with: '')
  #   fill_in('practice_user_id', with: @user.email)
  #   click_button('Update Practice')
  #   expect(page).to have_content('Innovation was successfully updated.')
  #   sleep 3
  #   expect(Practice.first.commontator_thread.subscribers.first).to eq(@user2)
  #   expect(Practice.first.commontator_thread.subscribers.last).to eq(@user)
  # end
end
