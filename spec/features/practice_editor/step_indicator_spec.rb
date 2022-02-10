require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', first_name: 'Foo', last_name: 'Bar', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @end_time = DateTime.new(2015, 1, 1, 11, 0, 0)
    PracticeEditorSession.create(user_id: @admin.id, practice_id: @practice.id, session_start_time: DateTime.now, session_end_time: @end_time, created_at: DateTime.now, updated_at: DateTime.now)
    page.driver.browser.manage.window.resize_to(1200, 600) # need to set this otherwise mobile version of editor displays
  end

  describe 'Step indicator' do
    before do
      login_as(@admin, :scope => :user, :run_callbacks => false)
      visit practice_path(@practice)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should display the step indicator on each page' do
      session_date = "#{@end_time.strftime("%-m/%-d/%Y")}"
      session_time = "#{@end_time.strftime("%I:%M %p")}"
      last_updated_txt = "#{@practice.name} last updated on #{session_date} at #{session_time} by #{@admin.first_name} #{@admin.last_name}"

      # editors
      visit practice_editors_path(@practice)
      expect(page).to have_content(last_updated_txt)
      within(:css, '.usa-step-indicator') do
        expect(page).to have_link(href: practice_editors_path(@practice))
        expect(page).to have_link(href: practice_introduction_path(@practice))
        expect(page).to have_link(href: practice_adoptions_path(@practice))
        expect(page).to have_link(href: practice_overview_path(@practice))
        expect(page).to have_link(href: practice_implementation_path(@practice))
        expect(page).to have_link(href: practice_about_path(@practice))
        segments = find_all('.usa-step-indicator__segment')
        editors_segment = segments.first
        editors_segment.has_css?('.usa-step-indicator__segment--current')
        expect(editors_segment).to have_content('Editors')
        introduction_segment = segments[1]
        introduction_segment.has_css?('.usa-step-indicator__segment')
      end

      # introduction
      visit practice_introduction_path(@practice)
      expect(page).to have_content(last_updated_txt)
      within(:css, '.usa-step-indicator') do
        expect(page).to have_link(href: practice_editors_path(@practice))
        expect(page).to have_link(href: practice_introduction_path(@practice))
        expect(page).to have_link(href: practice_adoptions_path(@practice))
        expect(page).to have_link(href: practice_overview_path(@practice))
        expect(page).to have_link(href: practice_implementation_path(@practice))
        expect(page).to have_link(href: practice_about_path(@practice))
        segments = find_all('.usa-step-indicator__segment')
        editors_segment = segments.first
        editors_segment.has_css?('.usa-step-indicator__segment--complete')
        introduction_segment = segments[1]
        introduction_segment.has_css?('.usa-step-indicator__segment--current')
        expect(introduction_segment).to have_content('Introduction')
        adoptions_segment = segments[2]
        adoptions_segment.has_css?('.usa-step-indicator__segment')
      end

      # adoptions
      visit practice_adoptions_path(@practice)
      expect(page).to have_content(last_updated_txt)
      within(:css, '.usa-step-indicator') do
        expect(page).to have_link(href: practice_editors_path(@practice))
        expect(page).to have_link(href: practice_introduction_path(@practice))
        expect(page).to have_link(href: practice_adoptions_path(@practice))
        expect(page).to have_link(href: practice_overview_path(@practice))
        expect(page).to have_link(href: practice_implementation_path(@practice))
        expect(page).to have_link(href: practice_about_path(@practice))
        segments = find_all('.usa-step-indicator__segment')
        introduction_segment = segments[1]
        introduction_segment.has_css?('.usa-step-indicator__segment--complete')
        adoptions_segment = segments[2]
        adoptions_segment.has_css?('.usa-step-indicator__segment--current')
        expect(adoptions_segment).to have_content('Adoptions')
        overview_segment = segments[3]
        overview_segment.has_css?('.usa-step-indicator__segment')
      end

      # overview
      visit practice_overview_path(@practice)
      expect(page).to have_content(last_updated_txt)
      within(:css, '.usa-step-indicator') do
        expect(page).to have_link(href: practice_editors_path(@practice))
        expect(page).to have_link(href: practice_introduction_path(@practice))
        expect(page).to have_link(href: practice_adoptions_path(@practice))
        expect(page).to have_link(href: practice_overview_path(@practice))
        expect(page).to have_link(href: practice_implementation_path(@practice))
        expect(page).to have_link(href: practice_about_path(@practice))
        segments = find_all('.usa-step-indicator__segment')
        adoptions_segment = segments[2]
        adoptions_segment.has_css?('.usa-step-indicator__segment--complete')
        overview_segment = segments[3]
        overview_segment.has_css?('.usa-step-indicator__segment--current')
        expect(overview_segment).to have_content('Overview')
        implementation_segment = segments[3]
        implementation_segment.has_css?('.usa-step-indicator__segment')
      end

      # implementation
      visit practice_implementation_path(@practice)
      expect(page).to have_content(last_updated_txt)
      within(:css, '.usa-step-indicator') do
        expect(page).to have_link(href: practice_editors_path(@practice))
        expect(page).to have_link(href: practice_introduction_path(@practice))
        expect(page).to have_link(href: practice_adoptions_path(@practice))
        expect(page).to have_link(href: practice_overview_path(@practice))
        expect(page).to have_link(href: practice_implementation_path(@practice))
        expect(page).to have_link(href: practice_about_path(@practice))
        segments = find_all('.usa-step-indicator__segment')
        overview_segment = segments[3]
        overview_segment.has_css?('.usa-step-indicator__segment--complete')
        implementation_segment = segments[4]
        implementation_segment.has_css?('.usa-step-indicator__segment--current')
        expect(implementation_segment).to have_content('Implementation')
        about_segment = segments[5]
        about_segment.has_css?('.usa-step-indicator__segment')
      end

      # about
      visit practice_about_path(@practice)
      expect(page).to have_content(last_updated_txt)
      within(:css, '.usa-step-indicator') do
        expect(page).to have_link(href: practice_editors_path(@practice))
        expect(page).to have_link(href: practice_introduction_path(@practice))
        expect(page).to have_link(href: practice_adoptions_path(@practice))
        expect(page).to have_link(href: practice_overview_path(@practice))
        expect(page).to have_link(href: practice_implementation_path(@practice))
        expect(page).to have_link(href: practice_about_path(@practice))
        segments = find_all('.usa-step-indicator__segment')
        implementation_segment = segments[4]
        implementation_segment.has_css?('.usa-step-indicator__segment--complete')
        about_segment = segments[5]
        about_segment.has_css?('.usa-step-indicator__segment--current')
        expect(about_segment).to have_content('About')
      end
    end
  end
end
