require 'rails_helper'

describe 'Admin email all editors button', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:editors) { create_list(:user, 3) }
  let!(:recently_updated_practice) do
    create(
      :practice,
      user: user,
      published: true,
      updated_at: 1.day.ago,
      last_email_date: 2.days.ago
    )
  end

  let!(:older_practice) do
    create(
      :practice,
      user: user,
      published: true,
      updated_at: 10.days.ago,
      last_email_date: 11.days.ago
    )
  end

  let!(:unemailed_practice) do
    create(
      :practice,
      user: user,
      published: true,
      updated_at: 5.days.ago,
      last_email_date: nil
    )
  end

  let!(:unpublished_practice) do
    create(
      :practice,
      user: user,
      published: false,
      updated_at: 3.days.ago,
      last_email_date: 4.days.ago
    )
  end

  before do
    Sidekiq::Worker.clear_all
    ActionMailer::Base.deliveries.clear
    login_as(admin, scope: :user, run_callbacks: false)
    visit admin_practices_path

    [recently_updated_practice, older_practice, unemailed_practice].each do |practice|
      create(:practice_editor, user: editors.first, innovable: practice)
    end

    page.driver.browser.manage.window.resize_to(1920, 1080)
  end

  after do
    Sidekiq::Testing.fake!
  end

  it 'sends an email to all editors of unfiltered and published practices' do
    create(:practice_editor, user: editors.second, innovable: recently_updated_practice)
    create(:practice_editor, user: user, innovable: recently_updated_practice)

    filter_practices_and_send_email

    Sidekiq::Worker.drain_all
    expect(Sidekiq::Worker.jobs.size).to eq(0)

    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 4

    email = emails.find { |e| e.to.include?(editors.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include older_practice.name
    expect(email.body.encoded).to include older_practice.updated_at.strftime('%m/%d/%Y')
    expect(email.body.encoded).to include unemailed_practice.name
    expect(email.body.encoded).to include unemailed_practice.updated_at.strftime('%m/%d/%Y')
    expect(email.body.encoded).to include recently_updated_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    email2 = emails.find { |e| e.to.include?(editors.second.email) }
    expect(email2.subject).to eq 'Important Update'

    expect(email2.body.encoded).to include recently_updated_practice.name
    expect(email2.body.encoded).not_to include older_practice.name
    expect(email2.body.encoded).not_to include unemailed_practice.name
    expect(email2.body.encoded).not_to include unpublished_practice.name

    user_email = emails.find { |e| e.to.include?(user.email) }
    expect(user_email.subject).to eq 'Important Update'

    expect(user_email.body.encoded).to include older_practice.name
    expect(user_email.body.encoded).to include unemailed_practice.name
    expect(user_email.body.encoded).to include recently_updated_practice.name
    expect(user_email.body.encoded).not_to include unpublished_practice.name

    expect(user_email.body.encoded.scan(recently_updated_practice.name).length).to eq(1)

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.subject).to eq('Confirmation: Diffusion Marketplace Innovation Batch Emails Sent')
    expect(admin_email.body.encoded).not_to include older_practice.name
    expect(admin_email.body.encoded).not_to include unemailed_practice.name
    expect(admin_email.body.encoded).not_to include recently_updated_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name
    expect(admin_email.body.encoded).to include("The above message has been sent to the editors and owners of all published Innovations")

    older_practice.reload
    unemailed_practice.reload
    recently_updated_practice.reload
    unpublished_practice.reload
    expect(older_practice.last_email_date.to_date).to eq(Date.current)
    expect(unemailed_practice.last_email_date.to_date).to eq(Date.current)
    expect(recently_updated_practice.last_email_date.to_date).to eq(Date.current)
    expect(unpublished_practice.last_email_date.to_date).not_to eq(Date.current)
  end

  it 'sends an email to all editors of practices filtered by "Not Updated Since"' do
    filter_practices_and_send_email('practice_batch_email[not_updated_since]', 7.days.ago)

    Sidekiq::Worker.drain_all
    expect(Sidekiq::Worker.jobs.size).to eq(0)

    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 3

    email = emails.find { |e| e.to.include?(editors.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include older_practice.name
    expect(email.body.encoded).not_to include unemailed_practice.name
    expect(email.body.encoded).not_to include recently_updated_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    user_email = emails.find { |e| e.to.include?(user.email) }
    expect(user_email.body.encoded).to include older_practice.name
    expect(user_email.body.encoded).not_to include unemailed_practice.name
    expect(user_email.body.encoded).not_to include recently_updated_practice.name
    expect(user_email.body.encoded).not_to include unpublished_practice.name

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.subject).to eq('Confirmation: Diffusion Marketplace Innovation Batch Emails Sent')
    expect(admin_email.body.encoded).to include("The above message has been sent to the editors and owners of the following Innovations:")
    expect(admin_email.body.encoded).to include older_practice.name
    expect(admin_email.body.encoded).not_to include unemailed_practice.name
    expect(admin_email.body.encoded).not_to include recently_updated_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name
    expect(admin_email.body.encoded).to include("not_updated_since: #{7.days.ago.to_date}")
  end

  it 'sends an email to all editors of practices filtered by "Not Emailed Since"' do
    filter_practices_and_send_email('practice_batch_email[not_emailed_since]', 12.days.ago)

    Sidekiq::Worker.drain_all
    expect(Sidekiq::Worker.jobs.size).to eq(0)

    emails = ActionMailer::Base.deliveries
    expect(emails.count).to eq 3

    email = emails.find { |e| e.to.include?(editors.first.email) }
    expect(email.subject).to eq 'Important Update'

    expect(email.body.encoded).to include unemailed_practice.name
    expect(email.body.encoded).not_to include older_practice.name
    expect(email.body.encoded).not_to include recently_updated_practice.name
    expect(email.body.encoded).not_to include unpublished_practice.name

    user_email = emails.find { |e| e.to.include?(user.email) }
    expect(user_email.body.encoded).to include unemailed_practice.name
    expect(user_email.body.encoded).not_to include older_practice.name
    expect(user_email.body.encoded).not_to include recently_updated_practice.name
    expect(user_email.body.encoded).not_to include unpublished_practice.name

    admin_email = emails.find { |e| e.to.include?(admin.email) }
    expect(admin_email.subject).to eq('Confirmation: Diffusion Marketplace Innovation Batch Emails Sent')
    expect(admin_email.body.encoded).to include("The above message has been sent to the editors and owners of the following Innovations:")
    expect(admin_email.body.encoded).to include unemailed_practice.name
    expect(admin_email.body.encoded).not_to include older_practice.name
    expect(admin_email.body.encoded).not_to include recently_updated_practice.name
    expect(admin_email.body.encoded).not_to include unpublished_practice.name
    expect(admin_email.body.encoded).to include("not_emailed_since: #{12.days.ago.to_date}")
  end

  def filter_practices_and_send_email(filter=nil, value=nil)
    click_link 'Send Email to Innovation Editors'
    fill_in 'practice_batch_email[subject]', with: 'Important Update'

    find('#emailMessage').click

    ready = false
    timeout = 10 # seconds
    start_time = Time.now

    while !ready && Time.now - start_time < timeout
      ready = page.evaluate_script("typeof tinymce !== 'undefined' && tinymce.get('emailMessage') !== null && tinymce.get('emailMessage').initialized")
      sleep 0.1 unless ready
    end

    raise "TinyMCE was not ready within #{timeout} seconds" unless ready

    # Proceed with actions now that TinyMCE is ready
    execute_script("tinymce.get('emailMessage').setContent('Please review the latest changes.')")

    filter ? (fill_in filter, with: value) : nil

    click_button 'Preview and Send'

    within('#previewModal') do
      click_button 'Send Email'
      page.driver.browser.switch_to.alert.accept
    end

    expect(page).to have_content('Your batch email to Innovation editors has been sent.')
  end
end
