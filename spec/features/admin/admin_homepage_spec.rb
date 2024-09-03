require 'rails_helper'

describe 'Homepage editor', type: :feature do
  before do
    @admin = create(:user, :admin, email: 'sandy.cheeks@va.gov')
    @image_file = "#{Rails.root}/spec/assets/charmander.png"
    login_as(@admin, scope: :user, run_callbacks: false)
  end

  describe 'Publishing' do
  	it 'prevents the user from deleting the current homepage' do
      Homepage.create(internal_title: 'august', published: true)
      visit admin_homepages_path
      within('#homepage_1') do
        expect(page).to have_link('Unpublish')
        click_link('Delete')
        page.accept_alert
      end
      expect(page).to have_content('Homepage must be unpublished before deleting')
  	end

  	it 'uses hardcoded backfill content when no homepage is available' do # remove this after the first homepage is created
      visit root_path
      titles = ['Featured Innovations', 'Trending Tags', 'Innovation Communities']
      titles.each { |title| expect(page).to have_content title }
      visit new_admin_homepage_path
      find('#homepage_submit_action')
        click_button 'Create Homepage'
      click_link 'Publish'
      visit root_path
      titles.each { |title| expect(page).not_to have_content title }
  	end

  	it 'unpublishes the current homepage when publishing a new page' do
  		Homepage.create(internal_title: 'august', published: true)
  		Homepage.create(internal_title: 'september', published: false)
  		visit admin_homepages_path
      within('#homepage_1') { expect(page).to have_link('Unpublish') }
      within('#homepage_2') { click_link('Publish') }
      within('#homepage_1') { expect(page).to have_link('Publish') }
      within('#homepage_2') { expect(page).to have_link('Unpublish') }
  	end
  end

  describe 'creating the page' do
  	it 'publishes section titles' do
      visit admin_homepages_path
      click_link 'New Homepage'
      fill_in 'Internal title', with: 'august'
      fill_in 'Section 1 Title', with: 'Featured Innovations'
      fill_in 'Section 2 Title', with: 'Trending Tags'
      fill_in 'Section 3 Title', with: 'Innovation Communities'
      save_page
      visit root_path
      expect(page).to have_content 'Featured Innovations'
      expect(page).to have_content 'Trending Tags'
      expect(page).to have_content 'Innovation Communities'
  	end

  	it 'creates homepage features', js:true do
      visit admin_homepages_path
      click_link 'New Homepage'
      fill_in 'Internal title', with: 'august'
      fill_in 'Section 1 Title', with: 'Custom title'
      click_link 'Add Feature'
      feature_form = find('.has_many_fields', match: :first)
      within(feature_form) do
        select '1', from: 'Section'
        fill_in 'Feature Title', with: 'A Very Cool Innovation'
        fill_in 'Description', with: "A finalist for the 2024 Shark Tank competition, this practice's impact on veteran health outcomes is..."
        fill_in 'Call to Action URL', with: '/about'
        fill_in 'Call to Action Text', with: 'Learn more'
        find('input[type="file"]').attach_file(@image_file)
        fill_in 'Image alt text', with: "A Charmander pokemon"
      end
      save_page
      visit admin_homepages_path
      click_link 'Publish'
      visit root_path
      expect(page).to have_content('Custom title')
      expect(page).to have_content('A Very Cool Innovation')
      expect(page).to have_content("A finalist for the 2024 Shark Tank competition, this practice's impact on veteran health outcomes is...")
      expect(page).to have_link('Learn more', href: '/about')
      expect(page).to have_css("img[alt='A Charmander pokemon']")
    end
  end

  describe 'deletes' do
    it 'images and their alt text', js: true  do
      visit admin_homepages_path
      click_link 'New Homepage'
      click_link 'Add Feature'
      feature_form = find('.has_many_fields', match: :first)
      within(feature_form) do
        select '1', from: 'Section'
        find('input[type="file"]').attach_file(@image_file)
        fill_in 'Image alt text', with: "A Charmander pokemon"
      end
      save_page
      visit admin_homepages_path
      click_link 'Publish'
      visit root_path
      expect(page).to have_css("img[alt='A Charmander pokemon']")
      visit admin_homepages_path
      click_link 'Edit'
      feature_form = find('.has_many_fields', match: :first)
      within(feature_form) do
        check 'Delete image?'
      end
      save_page
      click_link 'Edit Homepage'
      within(feature_form) do
        expect(page).not_to have_content('A Charmander pokemon')
      end
    end

    it 'homepage features' do
      Homepage.create
      HomepageFeature.create(homepage_id: 1, section_id: 1, title: 'A Very Cool Innovation')
      visit edit_admin_homepage_path(1)
      feature_form = find('.has_many_fields', match: :first)
      within(feature_form) do
        check 'Delete'
        expect(page).to have_selector("input[value='A Very Cool Innovation']")
      end
      save_page
      visit edit_admin_homepage_path(1)
      expect(page).not_to have_selector("input[value='A Very Cool Innovation']")
    end
  end

  describe 'page render' do
    it 'maximum of 3 items per section' do
      Homepage.create(published: true)
      4.times {|i| HomepageFeature.create(homepage_id: 1, section_id: 1, title: "Feature #{i + 1}") }
      visit root_path
      expect(page).to have_content('Feature 3')
      expect(page).not_to have_content('Feature 4')
    end

    it 'adjusts column sizes' do
      Homepage.create(published: true, section_title_one: 'Section 1', section_title_two: 'Section 2')
      3.times {|i| HomepageFeature.create(homepage_id: 1, section_id: 1, title: "Feature #{i + 1}") }
      2.times {|i| HomepageFeature.create(homepage_id: 1, section_id: 2, title: "Feature #{i + 1}") }
      visit root_path
      expect(page).to have_css('#section-1-feature-1.three-column-layout')
      expect(page).to have_css('#section-2-feature-1.two-column-layout')
    end
  end

  describe 'Preview' do
    it 'lets admins preview homepage' do      
      Homepage.create(internal_title: 'current', published: true, section_title_one: 'Old homepage')
      Homepage.create(internal_title: 'next month', published: false, section_title_one: 'Next month homepage')
      visit root_path
      expect(page).to have_content('Old homepage')
      visit admin_homepages_path
      within('#homepage_2') do
        expect(page).to have_content('Publish')
        click_link('Preview')
      end
      expect(page).to have_current_path('/homepages/2/preview')
      expect(page).to have_content('Next month homepage')
    end

    it 'hides previews from non-admins' do
      @non_admin = create(:user, email: 'spongebob@va.gov')
      login_as(@non_admin, scope: :user, run_callbacks: false)
      Homepage.create(internal_title: 'next month', published: false, section_title_one: 'Next month homepage')
      visit '/homepages/1/preview'
      expect(page).to have_current_path(root_path)
    end

  end

  def save_page
    find('input[type="submit"]', match: :first).click
  end
end
