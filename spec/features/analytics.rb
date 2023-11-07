require 'rails_helper'

describe 'DAP Google Analytics', type: :feature do
  before do
    allow(Rails.env).to receive(:production?).and_return(true)
    @admin = User.create!(email: 'user@va.gov', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming')
  end

  context 'includes snippet' do
    it 'on public pages' do
      public_page = Page.create!(title: 'Test', description: 'This is a public page', slug: 'public-page', page_group: @page_group, published: Time.now)
      visit '/programming/public-page'
      expect(page).to have_dap_snippet
    end

    it 'on public practices' do
      practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
      visit practice_path(practice)
      expect(page).to have_dap_snippet

      visit '/search'
      expect(page).to have_dap_snippet
    end
  end

  context 'excludes snippet' do
    before do
      login_as(@admin, scope: :user, run_callbacks: false)
      @unpublished_practice = Practice.create!(name: 'An unpublished practice', approved: true, published: false, tagline: 'Test tagline', user: @admin)
    end

    it 'on admin pages' do
      visit '/admin'
      expect(page).not_to have_dap_snippet
    end

    it 'on system pages' do
      visit '/system/status'
      expect(page).not_to have_dap_snippet
    end

    it 'on user pages' do
      visit user_path(@admin)
      expect(page).not_to have_dap_snippet
    end

    it 'on unpublished pages' do
      Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group)
      visit '/programming/test-page'
      expect(page).not_to have_dap_snippet
    end

    it 'on practice editor pages' do
      visit practice_overview_path(@unpublished_practice)
      expect(page).not_to have_dap_snippet
    end

    it 'on private practices' do
      visit practice_path(@unpublished_practice)
      expect(page).not_to have_dap_snippet
    end
  end

  def have_dap_snippet
    have_xpath '/html/head/script[contains(@src,"dap.digitalgov.gov")]', visible: false
  end
end
