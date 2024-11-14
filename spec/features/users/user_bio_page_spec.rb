require 'rails_helper'

RSpec.feature 'User Public Bio Page', type: :feature do
  let(:user) { create(:user) }

  before do
    visit user_bio_path(user.id)
  end

  context 'when all profile elements are present with alternate names and job title' do
    let(:user) do
      create(:user,
        first_name: 'John',
        last_name: 'Doe',
        accolades: 'LCSW, M.A.',
        alt_first_name: 'Jay',
        alt_last_name: 'Gorman',
        job_title: 'Doctor',
        alt_job_title: '2024 Entrepreneur in Residence Fellow',
        project: 'Veterans Socials: Expanding Social Support in the Community',
        work: 'Veterans Socials: Expanding Social Support in the Community, Peer Specialist Veterans Connect Over Coffee',
        bio: 'Dr. Jay Gorman is a clinical research psychologist in the VISN 1 New England Mental Illness Research, Education, and Clinical (MIRREC) Center and Director of the Social Reintegration Research Program at the VA Bedford Healthcare System',
        credentials: 'MIRREC Clinical Research Investigator, Director, Social Reintegration Research Program, VA Bedford Healthcare System',
        avatar: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/va-seal.png'), 'image/png'),
        granted_public_bio: true
      )
    end

    scenario 'displays all sections with full data, preferring alt names and job title' do
      expect(page).to have_css('img.avatar-profile-photo')
      expect(page).to have_content('Jay Gorman, LCSW, M.A.')
      expect(page).to have_content('2024 Entrepreneur in Residence Fellow')
      expect(page).to have_content('Veterans Socials: Expanding Social Support in the Community')
      expect(page).to have_content('Work')
      expect(page).to have_content('Veterans Socials: Expanding Social Support in the Community')
      expect(page).to have_content('Peer Specialist Veterans Connect Over Coffee')
      expect(page).to have_content('About')
      expect(page).to have_content('Dr. Jay Gorman is a clinical research psychologist in the VISN 1 New England Mental Illness Research, Education, and Clinical (MIRREC) Center and Director of the Social Reintegration Research Program at the VA Bedford Healthcare System')
      expect(page).to have_content('Credentials')
      expect(page).to have_content('MIRREC Clinical Research Investigator, Director, Social Reintegration Research Program, VA Bedford Healthcare System')
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
