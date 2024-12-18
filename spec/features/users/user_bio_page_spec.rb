require 'rails_helper'

RSpec.feature 'User Public Bio Page', type: :feature do
  describe 'user public bio is granted and all data is present' do
    let(:user) do
      create(:user,
        first_name: 'Johnathan',
        last_name: 'Doe',
        accolades: 'LCSW, M.A.',
        alt_first_name: 'John',
        alt_last_name: 'Goodman',
        job_title: 'Doctor',
        fellowship: '2024 Entrepreneur in Residence Fellow',
        project: 'Fake Project: Faking projects for test data',
        work: {0=>{'text'=> "Project One", 'link' => 'https://projectone.com'}, 1=>{'text'=> "Project Two", 'link' => 'https://projecttwo.com'}},
        bio: 'Dr. John Goodman is a fake doctor and this text is for testing purposes',
        alt_job_title: 'fake credentials text for testing purposes',
        avatar: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/va-seal.png'), 'image/png'),
        granted_public_bio: true
      )
    end

    it 'displays all sections with full data, preferring alt names and job title' do
      visit user_bio_path(user.id)
      expect(page).to have_css('img.avatar-profile-photo')
      expect(page).to have_content('John Goodman, LCSW, M.A.')
      expect(page).to have_content('2024 Entrepreneur in Residence Fellow')
      expect(page).to have_content('Fake Project: Faking projects for test data')
      expect(page).to have_content('Work')
      expect(page).to have_link('Project One', href: 'https://projectone.com')
      expect(page).to have_link('Project Two', href: 'https://projecttwo.com')
      expect(page).to have_content('About')
      expect(page).to have_content('Dr. John Goodman is a fake doctor and this text is for testing purposes')
      expect(page).to have_content('fake credentials text for testing purposes')
    end
  end

  describe 'optional bio data elements are missing, but basic info is present' do
    let(:user) do
      create(:user,
        first_name: 'Jane',
        last_name: 'Doe',
        job_title: nil,
        alt_first_name: nil,
        alt_last_name: nil,
        fellowship: nil,
        alt_job_title: nil,
        project: nil,
        work: nil,
        bio: 'Research scientist focusing on artificial intelligence.',
        avatar: nil,
        granted_public_bio: true
      )
    end

    it 'displays only the available information' do
      visit user_bio_path(user.id)
      expect(page).to have_content('Jane Doe')
      expect(page).to have_content('About')
      expect(page).to have_content('Research scientist focusing on artificial intelligence.')
      expect(page).not_to have_content('Work')
      expect(page).not_to have_content('Credentials')
      expect(page).not_to have_css('.avatar-profile-photo')
    end
  end

  describe 'when the user does not have granted_public_bio permission' do
    let(:user) { create(:user, granted_public_bio: false, first_name: 'NoAccess', last_name: 'User') }

    it 'redirects to the home page with an alert' do
      visit user_bio_path(user.id)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Bio page unavailable')
    end
  end

  describe 'when user is granted public bio' do
    let(:user_a) { create(:user, granted_public_bio: true, first_name: 'John', last_name: 'Goodman') }
    let(:user_b) { create(:user, granted_public_bio: true, first_name: 'Other', last_name: 'User') }
    let(:admin) { create(:user, :admin) }

    it 'links to edit profile page when logged in as the user' do
      login_as(user_a, scope: :user, run_callbacks: false)
      visit user_bio_path(user_a.id)
      expected_link_path = '/edit-profile'
      expect(page).to have_link('Edit profile', href: expected_link_path)
    end

    it "links to the given user's edit profile page when logged in as admin" do
      login_as(admin, scope: :user, run_callbacks: false)
      visit user_bio_path(user_a.id)
      expected_link_path = "/users/#{user_a.id}-John-Goodman/edit-profile"
      expect(page).to have_link('Edit profile', href: expected_link_path)
    end

    it "does not link to the given user's edit profile page when logged in as a non admin who isn't the user" do
      login_as(user_b, scope: :user, run_callbacks: false)
      visit user_bio_path(user_a.id)
      expected_link_path = "/users/#{user_a.id}-John-Goodman/edit-profile"
      expect(page).not_to have_link('Edit profile', href: expected_link_path)
      expect(page).not_to have_content('Edit profile')
    end
  end
end
