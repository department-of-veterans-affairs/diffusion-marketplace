require 'rails_helper'

RSpec.feature 'User Public Bio Page', type: :feature do
  let(:user) { create(:user) }

  before do
    visit user_bio_path(user.id)
  end

  context 'when all profile elements are present with alternate names and job title' do
    let(:user) do
      create(:user,
        first_name: 'Johnathan',
        last_name: 'Doe',
        accolades: 'LCSW, M.A.',
        alt_first_name: 'John',
        alt_last_name: 'Goodman',
        job_title: 'Doctor',
        alt_job_title: '2024 Entrepreneur in Residence Fellow',
        project: 'Fake Project: Faking projects for test data',
        work: 'Fake Project: Faking projects for test data, Fake work text',
        bio: 'Dr. John Goodman is a fake doctor and this text is for testing purposes',
        credentials: 'fake credentials text for testing purposes',
        avatar: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/va-seal.png'), 'image/png'),
        granted_public_bio: true
      )
    end

    scenario 'displays all sections with full data, preferring alt names and job title' do
      expect(page).to have_css('img.avatar-profile-photo')
      expect(page).to have_content('John Goodman, LCSW, M.A.')
      expect(page).to have_content('2024 Entrepreneur in Residence Fellow')
      expect(page).to have_content('Fake Project: Faking projects for test data')
      expect(page).to have_content('Work')
      expect(page).to have_content('Fake work text')
      expect(page).to have_content('About')
      expect(page).to have_content('Dr. John Goodman is a fake doctor and this text is for testing purposes')
      expect(page).to have_content('Credentials')
      expect(page).to have_content('fake credentials text for testing purposes')
    end
  end

  context 'when optional elements are missing, but basic info is present' do
    let(:user) do
      create(:user,
        first_name: 'Jane',
        last_name: 'Doe',
        job_title: nil,
        alt_first_name: nil,
        alt_last_name: nil,
        alt_job_title: nil,
        project: nil,
        work: nil,
        bio: 'Research scientist focusing on artificial intelligence.',
        credentials: nil,
        avatar: nil,
        granted_public_bio: true
      )
    end

    scenario 'displays only the available information' do
      expect(page).to have_content('Jane Doe')
      expect(page).to have_content('About')
      expect(page).to have_content('Research scientist focusing on artificial intelligence.')
      expect(page).not_to have_content('Work')
      expect(page).not_to have_content('Credentials')
      expect(page).not_to have_css('.avatar-profile-photo')
    end
  end

  context 'when the user does not have granted_public_bio permission' do
    let(:user) { create(:user, granted_public_bio: false, first_name: 'NoAccess', last_name: 'User') }

    scenario 'redirects to the home page with an alert' do
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Bio page unavailable')
    end
  end
end
