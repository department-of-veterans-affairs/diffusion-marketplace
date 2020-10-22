require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31))
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Implementation page' do
    it 'should be accessible' do
      visit practice_implementation_path(@practice)
      add_another_btns = find_all('.add_nested_fields')
      add_another_btns.each do |btn|
        btn.click
      end
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should have the correct continue and back links' do
      visit practice_implementation_path(@practice)
      within(:css, '.implementation') do
        expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/overview")
        expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/contact")
      end
    end
  end
end
