require 'rails_helper'

RSpec.feature 'User download flow', type: :feature do
  let(:user) { create(:user) }
  let(:practice) { create(:practice, :private_practice) }
  
  scenario 'User starts docx download after signing in' do
    practice_resource = create(:practice_resource, practice: practice, file_type: "docx")
    download_path = download_practice_practice_resource_path(
                practice_id: practice_resource.practice_id, 
                id: practice_resource.id,
                resource_type: practice_resource.class.to_s,
              )
    visit download_path

    expect(current_path).to eq(new_user_session_path)

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    downloaded_file_path = "#{Rails.root}/tmp/downloads/dummy.docx"

    downloaded = false
    timeout = 5
    start_time = Time.now

    until downloaded || Time.now - start_time > timeout
      sleep 1
      downloaded = File.exist?(downloaded_file_path)
    end
    expect(downloaded).to be true

    File.delete(downloaded_file_path)

    expect(current_path).to eq("/practice_resources/download_and_redirect")
    expect(page).to have_content("Your download should begin shortly.")
    expect(page).to have_content("It will either open in a new tab or appear in your browser's downloads folder.")

    download_link = find("a[href='#{practice_resource.attachment_s3_presigned_url}']", visible: :all)
    expect(download_link).to be_visible
    download_link.click

    start_time = Time.now
    downloaded = false

    until downloaded || Time.now - start_time > timeout
      sleep 1
      downloaded = File.exist?(downloaded_file_path)
    end
    expect(downloaded).to be true

    practice_link = find("a[href='#{practice_path(practice)}']", visible: :all)
    practice_link.click
    expect(URI.parse(current_url).path).to eq(practice_path(practice))
  end

  scenario 'User starts PDF download after signing in' do
    practice_resource = create(:practice_resource, practice: practice)

    download_path = download_practice_practice_resource_path(
                practice_id: practice_resource.practice_id, 
                id: practice_resource.id,
                resource_type: practice_resource.class.to_s,
              )
    visit download_path

    expect(current_path).to eq(new_user_session_path)

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
    expect(page.driver.browser.window_handles.length).to eq(2)

    expect(current_path).to eq("/practice_resources/download_and_redirect")
    expect(page).to have_content("Your download should begin shortly.")
    expect(page).to have_content("It will either open in a new tab or appear in your browser's downloads folder.")
  end
end
