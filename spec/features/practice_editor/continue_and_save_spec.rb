require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'retsu.unohana@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Continue button' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
    end

    it 'should save the users work and advance them to the next page in the editor when clicked' do
      visit practice_origin_path(@practice)
      origin = 'This practice was founded on the basis of being awesome'
      creator_name = 'Byakuya Kuchiki'
      creator_role = 'Captain of the Sixth Division in the Thirteen Cour Guard Squads'
      image_path = File.join(Rails.root, '/spec/assets/charmander.png')
      photo_caption = 'This is the cutest charmander image ever'
      fill_in('Origin story', with: origin)
      fill_in('Name', with: creator_name)
      fill_in('Role', with: creator_role)
      find('.continue-and-save').click

      @practice.reload
      expect(page).to have_content('Practice was successfully updated')
      expect(page).to have_content('Impact')
      expect(page).to have_content('Showcase real stories of how your practice is making an impact.')
      expect(@practice.origin_story).to eq(origin)
      expect(@practice.practice_creators.count).to eq(1)

      attach_file('Upload photo', image_path)
      all('.practice-editor-image-caption').first.set(photo_caption)
      find('.continue-and-save').click

      @practice.reload
      expect(page).to have_content('Practice was successfully updated')
      expect(page).to have_content('Documentation')
      expect(@practice.impact_photos.count).to eq(1)
    end

    it 'should not allow a user to move to the next page if there is a required field not filled out' do
      visit practice_overview_path(@practice)
      find('.continue-and-save').click
      email_message = all('.practice-editor-overview-statement-input').first.native.attribute('validationMessage')
      expect(email_message).to eq('Please fill out this field.')
    end
  end
end