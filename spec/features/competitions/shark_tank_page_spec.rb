require 'rails_helper'

describe 'Shark Tank landing page', type: :feature do
  before do
    @user = User.create!(email: 'gin.ichimaru@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline')
    @practice2 = Practice.create!(name: 'A second public practice', approved: true, published: true, tagline: 'Test tagline')
    @practice3 = Practice.create!(name: 'A third public practice', approved: true, published: true, tagline: 'Test tagline')
    @badge = Badge.create!(name: 'Shark Tank')
    @badge_practice = BadgePractice.create!(badge_id: @badge.id, practice_id: @practice.id)
    @badge_practice2 = BadgePractice.create!(badge_id: @badge.id, practice_id: @practice2.id)
    @badge_practice3 = BadgePractice.create!(badge_id: @badge.id, practice_id: @practice3.id)
  end

  it 'should be there' do
    visit '/'
    click_on('Shark Tank Competition')
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Submit your practice application by May 1, 2020!')
    expect(page).to have_content('Eligibility requirements')
    expect(page).to have_content('FAQs')
  end

  def visit_shark_tank_page
    visit '/competitions/shark-tank'
  end

  it 'should display the past shark tank winners' do
    visit_shark_tank_page
    expect(page).to have_content('Previous Shark Tank Winners')
    expect(page).to have_content(@practice.name)
    expect(page).to have_content(@practice2.name)
    expect(page).to have_content(@practice3.name)
  end

  it 'should allow the user to visit a practice page when they click on a practice card' do
    visit_shark_tank_page
    click_on(@practice.name)
    expect(page).to have_content('A public practice')
  end
end