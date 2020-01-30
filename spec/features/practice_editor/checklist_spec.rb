require 'rails_helper'

describe 'Practice editor', type: :feature do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @approver = User.create!(email: 'tosen.kaname@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @user = User.create!(email: 'jushiro.ukitake@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline')
  end

  describe 'Checklist page' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_checklist_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should be there' do
      expect(page).to have_content('Checklist')
      expect(page).to have_link(class: 'editor-back-to-link', href: "/practices/#{@practice.slug}/edit/contact")
      expect(page).to have_link(class: 'editor-continue-link', href: "/practices/#{@practice.slug}/publication_validation")
    end

    fit 'when no data is present, should allow the user to add a practice permission and additional resource' do
      within(:css, '#sortable_permissions') do
        fill_in('Step', with: 'Step 1')
        fill_in('Description', with: 'Description 1')

      end
    end
  end
end