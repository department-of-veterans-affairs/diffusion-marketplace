require 'rails_helper'

describe 'Admin Topics Tab', type: :feature do
  before do
    @admin = User.create!(email: 'admin-fake-user-1231231123@va.gov', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @img_path_1 = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    @img_path_2 = "#{Rails.root}/spec/assets/charmander.png"
    @img_path_3 = "#{Rails.root}/spec/assets/SpongeBob.png"
    Topic.create(title: "Mock topic one", description: "Description for mock topic 1", url: '/diffusion-map', cta_text: "Click here for diffusion map", attachment: File.new(@img_path_1))
    Topic.create(title: "Mock topic two", description: "Description for mock topic 2", url: 'https://www.va.gov', cta_text: "Click here for Veterans Affairs website", attachment: File.new(@img_path_2), featured: true)
    login_as(@admin, scope: :user, run_callbacks: false)
  end

  it 'should display existing topics' do
    visit '/admin'
    click_link 'Topics'
    featured_col_values = find_all('.status_tag')
    expect(page).to have_content('Mock topic two')
    expect(page).to have_content('https://www.va.gov')
    expect(featured_col_values.first.text).to eq "YES"
    expect(page).to have_content('Mock topic one')
    expect(page).to have_content('/diffusion-map')
    expect(featured_col_values.last.text).to eq "NO"
    visit '/'
    expect(page).to have_content('FEATURED TOPIC')
    expect(page).to have_content('Mock topic two')
    expect(page).to have_content('Description for mock topic 2')
    expect(page).to have_link('Click here for Veterans Affairs website', href: 'https://www.va.gov')
  end

  it 'allow adding and featuring a new topic' do
    visit '/admin'
    click_link 'Topics'
    click_link('New Topic')
    fill_in('Title', with: 'Mock topic three')
    fill_in('Description', with: "Description for mock topic 3")
    fill_in('Call to action URL', with: "/visns")
    fill_in('Call to action text', with: "Go see VISNs here")
    find('#topic_attachment').attach_file(@img_path_3)
    click_button('Create Topic')
    expect(page).to have_content('Topic was successfully created.')
    visit '/admin/topics'
    expect(page).to have_content('Mock topic three')
    expect(page).to have_content('/visns')
    featured_col_values = find_all('.status_tag')
    expect(featured_col_values.first.text).to eq "NO"
    find("a[href='/admin/topics/3/feature']").click
    featured_col_values = find_all('.status_tag')
    expect(page).to have_content("Topic with ID 3 is now featured.")
    expect(featured_col_values.first.text).to eq "YES"
    expect(featured_col_values[1].text).to eq "NO"
    visit '/'
    expect(page).to have_content('FEATURED TOPIC')
    expect(page).to have_content('Mock topic three')
    expect(page).to have_content('Description for mock topic 3')
    expect(page).to have_link('Go see VISNs here', href: visns_path)
    visit '/admin/topics'
    find("a[href='/admin/topics/3/feature']").click
    featured_col_values = find_all('.status_tag')
    expect(page).to have_content("Topic with ID 3 is now unfeatured.")
    expect(featured_col_values.first.text).to eq "NO"
    visit '/'
    expect(page).to have_no_content('FEATURED TOPIC')
  end

  it 'allow editing and deleting an existing topic' do
    visit '/admin'
    click_link 'Topics'
    find_all('.edit_link').first.click
    fill_in('Title', with: 'Mock updated topic two')
    find('#topic_attachment').attach_file(@img_path_3)
    click_button('Update Topic')
    expect(page).to have_content('Topic was successfully updated.')
    visit '/'
    expect(page).to have_content('FEATURED TOPIC')
    expect(page).to have_content('Mock updated topic two')
    visit '/admin'
    click_link 'Topics'
    find_all('.delete_link').first.click
    page.accept_alert
    expect(page).to have_content('Topic was successfully destroyed.')
    visit '/'
    expect(page).to have_no_content('FEATURED TOPIC')
  end
end
