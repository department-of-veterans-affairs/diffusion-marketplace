require 'rails_helper'

describe 'Admin VISN Liaisons Tab', type: :feature do
  before do
    @admin = User.create!(email: 'admin-test39127129@va.gov', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @visn = Visn.create!(name: 'Test VISN', number: 2)
    @visn_2 = Visn.create!(name: 'Desert VISN', number: 3)
    @visn_liaison = VisnLiaison.create!(first_name: 'Ash', last_name: 'Ketchum', email: 'ash-ketchum1231243@va.gov', primary: true, visn_id: @visn[:id])
    @visn_liaison_2 = VisnLiaison.create!(first_name: 'John', last_name: 'Smith', email:'john-smith139023@va.gov', primary: false, visn_id: @visn[:id])
    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin'
    click_link 'Visn Liaisons'
  end

  it 'should show all VISN liaisons and all actions' do
    within(:css, 'thead') do
      expect(page).to have_content("Id")
      expect(page).to have_content("First Name")
      expect(page).to have_content("Last Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Primary")
      expect(page).to have_content("VISN number")
    end

    within(:css, 'tbody') do
      expect(page).to have_content('Ash')
      expect(page).to have_content('Ketchum')
      expect(page).to have_content('ash-ketchum1231243@va.gov')
      expect(page).to have_content('John')
      expect(page).to have_content('Smith')
      expect(page).to have_content('john-smith139023@va.gov')
      expect(page).to have_content('YES')
      expect(page).to have_content('NO')
      expect(page).to have_content('2')
      expect(page).to have_link('View')
      expect(page).to have_link('Edit')
      expect(page).to have_link('Delete')
      expect(page).to have_link('Make Secondary')
      expect(page).to have_link('Make Primary')
    end
  end

  it "should allow toggling of a VISN liaison\'s primary status" do
    click_link('Make Primary')
    expect(page).to have_content('There can be only one primary contact for VISN 2 - Test VISN.')
    click_link('Make Secondary')
    expect(page).to have_content('VISN liaison, Ash Ketchum, has been made a secondary contact of VISN 2 - Test VISN.')
    find("a[href='/admin/visn_liaisons/#{@visn_liaison[:id]}/set_primary']").click
    expect(page).to have_content('VISN liaison, Ash Ketchum, has been made a primary contact of VISN 2 - Test VISN.')
  end

  it 'should allow creating a new VISN liaison' do
    click_link 'New Visn Liaison'
    fill_form
    select('VISN 2 - Test VISN', from: 'visn_liaison_visn_id')
    click_on('Create Visn liaison')
    fill_form
    select('VISN 3 - Desert VISN', from: 'visn_liaison_visn_id')
    click_on('Create Visn liaison')
    expect(page).to have_current_path(new_admin_visn_liaison_path)
    expect(page).to have_content('VISN liaison was successfully created.')
    find_all("a[href='/admin/visn_liaisons']").first.click
    find_all(".view_link").first.click
    check_for_liaison_update
  end

  it 'should allow editing a VISN liaison' do
    find("a[href='/admin/visn_liaisons/#{@visn_liaison_2[:id]}/edit']").click
    expect(page).to have_field('First name', with: 'John')
    expect(page).to have_field('Last name', with: 'Smith')
    expect(page).to have_field('Email', with: 'john-smith139023@va.gov')
    expect(page).to have_select('visn_liaison_visn_id', selected: 'VISN 2 - Test VISN')
    expect(find_all("input[name='visn_liaison[primary]']", visible: false).first.value).to eq('0')
    fill_form
    click_on('Update Visn liaison')
    expect(page).to have_content('There can be only one primary contact for VISN 2 - Test VISN.')
    fill_form
    select('VISN 3 - Desert VISN', from: 'visn_liaison_visn_id')
    click_on('Update Visn liaison')
    find_all("a[href='/admin/visn_liaisons']").first.click
    find_all(".view_link").first.click
    check_for_liaison_update
  end

  it 'should allow deleting a VISN liaison' do
    expect(page).to have_content('John')
    expect(page).to have_content('Smith')
    expect(page).to have_content('john-smith139023@va.gov')
    find_all(".delete_link").first.click
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content('Visn liaison was successfully destroyed.')
    expect(page).to have_no_content('John')
    expect(page).to have_no_content('Smith')
    expect(page).to have_no_content('john-smith139023@va.gov')
  end

  def check_for_liaison_update
    expect(page).to have_content('Test First Name')
    expect(page).to have_content('Test Last Name')
    expect(page).to have_content('test-email239012309@va.gov')
    expect(page).to have_content('YES')
    expect(page).to have_content('3')
  end

  def fill_form
    fill_in('visn_liaison_first_name', with: 'Test First Name')
    fill_in('visn_liaison_last_name', with: 'Test Last Name')
    fill_in('visn_liaison_email', with: 'test-email239012309@va.gov')
    find(:css, "#visn_liaison_primary").set(true)
  end
end
