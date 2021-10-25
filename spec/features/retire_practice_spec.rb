require 'rails_helper'

describe 'retired practices', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', featured: true, highlight: true, user: @user, retired: true, retired_reason: 'Was not a good practice')
  end

  it 'Should display retirement blurbs and reason' do
    # Login as an authenticated user and visit the practice page
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit practice_path(@practice)
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('This innovation is no longer being updated.')
    expect(page).to have_content('Was not a good practice')
    expect(page).to have_content('Comments and replies are disabled for retired innovations and public users.')
  end


  end
