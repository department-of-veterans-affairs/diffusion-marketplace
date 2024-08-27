require 'rails_helper'

describe 'Homepage editor', type: :feature do
  before do
    @admin = create(:user, :admin, email: 'sandy.cheeks@va.gov')
    @image_file = "#{Rails.root}/spec/assets/charmander.png"
    login_as(@admin, scope: :user, run_callbacks: false)
  end

  describe 'Publishing' do
  	it 'warns the user about unpublishing the homepage' do
  	end

  	it 'prevents the user from deleting the current homepage' do
      Homepage.create(internal_title: 'august', published: true)
      visit admin_homepages_path
      within('#homepage_1') do
        expect(page).to have_link('Unpublish')
        click_link('Delete')
        expect(page).to have_content('Homepage must be unpublished before deleting')
      end
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
  		
      within('#homepage_1') do
  			expect(page).to have_link('Unpublish')
  		end
  		
      within('#homepage_2') do
  			click_link('Publish')
  		end
  		
      within('#homepage_1') do
  			expect(page).to have_link('Publish')
  		
      end
  		
      within('#homepage_2') do
  			expect(page).to have_link('Unpublish')
  		end
  	end
  end

  describe 'creating the page' do
  	it 'publishes section titles' do
      visit admin_homepages_path
      click 'New homepage'
      fill_in 'Internal title', with: 'august'
      fill_in 'Section 1 Title', with: 'Featured Innovations'
      fill_in 'Section 2 Title', with: 'Trending Tags'
      fill_in 'Section 3 Title', with: 'Innovation Communities'
      click_button 'Create Homepage'
      visit root_path
      expect(page).to have_content 'Featured Innovations'
      expect(page).to have_content 'Trending Tags'
      expect(page).to have_content 'Innovation Communities'
  	end

  	it 'creates homepage features' do
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
      expect(page).to have_css('#featured-innovation-1.three-column-layout')
      expect(page).to have_css('#featured-tag-1.two-column-layout')
    end
  end

end