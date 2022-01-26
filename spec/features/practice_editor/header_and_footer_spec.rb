require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @published_pr = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
    @unpublished_pr = Practice.create!(name: 'An unpublished practice', slug: 'a-unpublished-practice', approved: true, published: false, tagline: 'Test tagline', user: @admin)
    @admin.add_role(User::USER_ROLES[0].to_sym)
  end

  describe 'Header and footer' do
    context 'for a published practice' do
      before do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        visit practice_path(@published_pr)
        expect(page).to be_accessible.according_to :wcag2a, :section508
      end

      it 'should display the correct header and footer on each page' do
        click_on('Edit innovation')
        expect(page).to have_current_path(practice_metrics_path(@published_pr))
        editor_header = "#dm-practice-editor-header"
        editor_footer = "footer"

        # metrics
        expect(page).to have_current_path(practice_metrics_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_no_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_no_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_no_content('Save and continue')
        end
        click_link('Edit your innovation')

        # editors
        expect(page).to have_current_path(practice_editors_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_no_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_introduction_path(@published_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_introduction_path(@published_pr)

        # introduction
        expect(page).to have_current_path(practice_introduction_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_editors_path(@published_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_adoptions_path(@published_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_adoptions_path(@published_pr)

        # adoptions
        expect(page).to have_current_path(practice_adoptions_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_introduction_path(@published_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_overview_path(@published_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_overview_path(@published_pr)

        # overview
        expect(page).to have_current_path(practice_overview_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_adoptions_path(@published_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_implementation_path(@published_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_implementation_path(@published_pr)

        # implementation
        expect(page).to have_current_path(practice_implementation_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_overview_path(@published_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_about_path(@published_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_about_path(@published_pr)

        # about
        expect(page).to have_current_path(practice_about_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_implementation_path(@published_pr))
          expect(page).to have_no_content('Save and continue')
        end
      end
    end

    context 'for an unpublished practice' do
      before do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        visit practice_path(@unpublished_pr)
        expect(page).to be_accessible.according_to :wcag2a, :section508
      end

      it 'should display the correct header and footer on each page' do
        click_on('Edit innovation')
        expect(page).to have_current_path(practice_metrics_path(@unpublished_pr))
        editor_header = "#dm-practice-editor-header"
        editor_footer = "footer"

        # metrics
        expect(page).to have_current_path(practice_metrics_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_no_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_no_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_no_content('Save and continue')
        end
        click_link('Edit your innovation')

        # editors
        expect(page).to have_current_path(practice_editors_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_no_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_introduction_path(@unpublished_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_introduction_path(@unpublished_pr)

        # introduction
        expect(page).to have_current_path(practice_introduction_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_editors_path(@unpublished_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_adoptions_path(@unpublished_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_adoptions_path(@unpublished_pr)

        # adoptions
        expect(page).to have_current_path(practice_adoptions_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_introduction_path(@unpublished_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_overview_path(@unpublished_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_overview_path(@unpublished_pr)

        # overview
        expect(page).to have_current_path(practice_overview_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_adoptions_path(@unpublished_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_implementation_path(@unpublished_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_implementation_path(@unpublished_pr)

        # implementation
        expect(page).to have_current_path(practice_implementation_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_overview_path(@unpublished_pr))
          expect(page).to have_link(class: 'usa-button--secondary', href: practice_about_path(@unpublished_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_about_path(@unpublished_pr)

        # about
        expect(page).to have_current_path(practice_about_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').first
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').last
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
          expect(page).to have_no_content('Save and update')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(class: 'dm-button--outline-secondary', href: practice_implementation_path(@unpublished_pr))
          expect(page).to have_no_content('Save and continue')
        end
      end
    end
  end
end
