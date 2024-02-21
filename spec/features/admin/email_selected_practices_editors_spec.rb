require 'rails_helper'

describe 'Admin email all editors button', type: :feature, js: true do
  let(:admin) { create(:user, :admin) }
  let!(:users) { create_list(:user, 3) }
  let!(:recently_updated_practice) do
    create(
      :practice,
      user: admin,
      published: true,
      updated_at: 1.day.ago,
      last_email_date: 2.days.ago
    )
  end

  let!(:older_practice) do
    create(
      :practice,
      user: admin,
      published: true,
      updated_at: 10.days.ago,
      last_email_date: 11.days.ago
    )
  end

  let!(:unemailed_practice) do
    create(
      :practice,
      user: admin,
      published: true,
      updated_at: 5.days.ago,
      last_email_date: nil
    )
  end

  let!(:unpublished_practice) do
    create(
      :practice,
      user: admin,
      published: false,
      updated_at: 3.days.ago,
      last_email_date: 4.days.ago
    )
  end

  before do
    ActionMailer::Base.deliveries.clear
    login_as(admin, scope: :user, run_callbacks: false)
    visit admin_practices_path

    [recently_updated_practice, older_practice, unemailed_practice].each do |practice|
      create(:practice_editor, user: users.first, practice: practice)
    end

    page.driver.browser.manage.window.resize_to(1920, 1080)
  end

  it 'sends an email to all editors of unfiltered and published practices' do
    create(:practice_editor, user: users.second, practice: recently_updated_practice)
    2.times do
      create(:practice_editor, user: admin, practice: recently_updated_practice)
    end

    filter_practices_and_send_email

    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 3

    email = emails.find { |e| e.to.include?(users.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include older_practice.name
    expect(email.body.encoded).to include unemailed_practice.name
    expect(email.body.encoded).to include recently_updated_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    email2 = emails.find { |e| e.to.include?(users.second.email) }
    expect(email2.subject).to eq 'Important Update'

    expect(email2.body.encoded).to include recently_updated_practice.name
    expect(email2.body.encoded).not_to include older_practice.name
    expect(email2.body.encoded).not_to include unemailed_practice.name
    expect(email2.body.encoded).not_to include unpublished_practice.name

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.subject).to eq 'Important Update'

    expect(admin_email.body.encoded).to include older_practice.name
    expect(admin_email.body.encoded).to include unemailed_practice.name
    expect(admin_email.body.encoded).to include recently_updated_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name

    # a practice should show up no more than once for an editor
    expect(admin_email.body.encoded.scan(recently_updated_practice.name).length).to eq(1)
  end

  it 'sends an email to all editors of practices filtered by "Not Updated Since"' do
    filter_practices_and_send_email('q_not_updated_since', 7.days.ago.to_date.to_s)
    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 2

    email = emails.find { |e| e.to.include?(users.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include older_practice.name
    expect(email.body.encoded).not_to include unemailed_practice.name
    expect(email.body.encoded).not_to include recently_updated_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.body.encoded).to include older_practice.name
    expect(admin_email.body.encoded).not_to include unemailed_practice.name
    expect(admin_email.body.encoded).not_to include recently_updated_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name
  end

  it 'sends an email to all editors of practices filtered by "Not Emailed Since"' do
    filter_practices_and_send_email('q_not_emailed_since', 12.days.ago.to_date.to_s)

    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 2

    email = emails.find { |e| e.to.include?(users.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include unemailed_practice.name
    expect(email.body.encoded).not_to include older_practice.name
    expect(email.body.encoded).not_to include recently_updated_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.body.encoded).to include unemailed_practice.name
    expect(admin_email.body.encoded).not_to include older_practice.name
    expect(admin_email.body.encoded).not_to include recently_updated_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name
  end

  it 'sends an email to all editors of practices filtered by "Name"' do
    filter_practices_and_send_email('q_name', recently_updated_practice.name)

    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 2

    email = emails.find { |e| e.to.include?(users.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include recently_updated_practice.name
    expect(email.body.encoded).not_to include unemailed_practice.name
    expect(email.body.encoded).not_to include older_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.body.encoded).to include recently_updated_practice.name
    expect(admin_email.body.encoded).not_to include unemailed_practice.name
    expect(admin_email.body.encoded).not_to include older_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name
  end

  it 'sends an email to all editors of practices filtered by "Owner Email"' do
    filter_practices_and_send_email('q_user_email', admin.email)

    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 2

    email = emails.find { |e| e.to.include?(users.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include recently_updated_practice.name
    expect(email.body.encoded).to include unemailed_practice.name
    expect(email.body.encoded).to include older_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.body.encoded).to include recently_updated_practice.name
    expect(admin_email.body.encoded).to include unemailed_practice.name
    expect(admin_email.body.encoded).to include older_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name
  end

  def filter_practices_and_send_email(filter=nil, value=nil)
    filter ? (fill_in filter, with: value) : nil
    click_button 'Filter'
    click_link 'Send Email to Innovation Editors'
    fill_in 'email[subject]', with: 'Important Update'
    find('#emailMessage').click
    execute_script("tinyMCE.get('emailMessage').setContent('Please review the latest changes.')")
    click_button 'Preview and Send'

    within('#previewModal') do
      click_button 'Send Email'
      page.driver.browser.switch_to.alert.accept
    end

    expect(page).to have_content('Your batch email to Innovation editors has been sent.')
  end
end