require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @published_pr = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: @admin)
    @unpublished_pr = Practice.create!(name: 'An unpublished practice', slug: 'a-unpublished-practice', approved: true, published: false, tagline: 'Test tagline', user: @admin)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    visn_1 = Visn.create!(name: 'VISN 1', number: 1)
    VaFacility.create!(
      visn: visn_1,
      station_number: "402GA",
      official_station_name: "Caribou VA Clinic",
      common_name: "Caribou",
      latitude: "44.2802701",
      longitude: "-69.70413586",
      street_address_state: "ME"
    )
  end

  describe 'Header and footer' do
    context 'for a published practice' do
      before do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        visit practice_path(@published_pr)
      end

      it 'should display the correct header and footer on each page' do
        click_on('Edit innovation')
        expect(page).to have_current_path(practice_editors_path(@published_pr))
        editor_header = "#dm-practice-editor-header"
        editor_footer = "footer"

        # metrics
        click_link('Metrics')
        expect(page).to have_current_path(practice_metrics_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_no_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
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
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_no_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(href: practice_introduction_path(@published_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_introduction_path(@published_pr)

        # introduction
        expect(page).to have_current_path(practice_introduction_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_editors_path(@published_pr))
          expect(page).to have_link(href: practice_adoptions_path(@published_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_adoptions_path(@published_pr)

        # adoptions
        expect(page).to have_current_path(practice_adoptions_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(href: practice_introduction_path(@published_pr))
          expect(page).to have_link(href: practice_overview_path(@published_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_overview_path(@published_pr)

        # overview
        expect(page).to have_current_path(practice_overview_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_adoptions_path(@published_pr))
          expect(page).to have_link(href: practice_implementation_path(@published_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_implementation_path(@published_pr)

        # implementation
        expect(page).to have_current_path(practice_implementation_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_overview_path(@published_pr))
          expect(page).to have_link(href: practice_about_path(@published_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_about_path(@published_pr)

        # about
        expect(page).to have_current_path(practice_about_path(@published_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@published_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_implementation_path(@published_pr))
          expect(page).to have_no_content('Save and continue')
        end
      end
    end

    context 'for an unpublished practice' do
      before do
        login_as(@admin, :scope => :user, :run_callbacks => false)
        visit practice_path(@unpublished_pr)
      end

      it 'should display the correct header and footer on each page' do
        click_on('Edit innovation')
        expect(page).to have_current_path(practice_editors_path(@unpublished_pr))
        editor_header = "#dm-practice-editor-header"
        editor_footer = "footer"

        # metrics
        click_on('Metrics')
        expect(page).to have_current_path(practice_metrics_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_no_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
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
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_no_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(href: practice_introduction_path(@unpublished_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_introduction_path(@unpublished_pr)

        # introduction
        expect(page).to have_current_path(practice_introduction_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_editors_path(@unpublished_pr))
          expect(page).to have_link(href: practice_adoptions_path(@unpublished_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_adoptions_path(@unpublished_pr)

        # adoptions
        expect(page).to have_current_path(practice_adoptions_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_content('Metrics')
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_no_content('Save as draft')
          expect(page).to have_no_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_content('Continue')
          expect(page).to have_link(href: practice_introduction_path(@unpublished_pr))
          expect(page).to have_link(href: practice_overview_path(@unpublished_pr))
          expect(page).to have_no_content('Save and continue')
        end
        visit practice_overview_path(@unpublished_pr)

        # overview
        expect(page).to have_current_path(practice_overview_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_adoptions_path(@unpublished_pr))
          expect(page).to have_link(href: practice_implementation_path(@unpublished_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_implementation_path(@unpublished_pr)

        # implementation
        expect(page).to have_current_path(practice_implementation_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_overview_path(@unpublished_pr))
          expect(page).to have_link(href: practice_about_path(@unpublished_pr))
          expect(page).to have_content('Save and continue')
        end
        visit practice_about_path(@unpublished_pr)

        # about
        expect(page).to have_current_path(practice_about_path(@unpublished_pr))
        within(:css, editor_header) do
          expect(page).to have_no_link(href: root_path)
          expect(page).to have_link(href: practice_metrics_path(@unpublished_pr))
          metrics_nav_link = find_all('.usa-nav__primary-item').last
          expect(metrics_nav_link).to have_no_css('.usa-current')
          expect(page).to have_content('Editing guide')
          expect(page).to have_content('Edit your innovation')
          edit_nav_link = find_all('.usa-nav__primary-item').first
          expect(edit_nav_link).to have_css('.usa-current')
          expect(page).to have_content('Save as draft')
          expect(page).to have_content('Save and publish')
        end
        within(editor_footer) do
          expect(page).to have_content('Back')
          expect(page).to have_no_content('Continue')
          expect(page).to have_link(href: practice_implementation_path(@unpublished_pr))
          expect(page).to have_no_content('Save and continue')
        end
      end
    end

    context 'clicking the X button' do
      before do
        login_as(@admin, :scope => :user, :run_callbacks => false)
      end

      it 'should return to the practice show page without a close modal for metrics, editors, and adoptions page' do
        visit practice_metrics_path(@unpublished_pr)
        find('.dm-button--close-icon').click
        expect(page).to have_selector('.show-main', visible: true)
        expect(page).to have_current_path(practice_path(@unpublished_pr))
        visit practice_editors_path(@unpublished_pr)
        find('.dm-button--close-icon').click
        expect(page).to have_selector('.show-main', visible: true)
        expect(page).to have_current_path(practice_path(@unpublished_pr))
        visit practice_adoptions_path(@unpublished_pr)
        find('.dm-button--close-icon').click
        expect(page).to have_selector('.show-main', visible: true)
        expect(page).to have_current_path(practice_path(@unpublished_pr))
      end

      it 'should show a close modal for introduction, overview, implementation, about page' do
        # continue editing and save on exit
        visit practice_introduction_path(@unpublished_pr)
        fill_in('Name', with: 'This is a newly titled practice')
        find('.dm-button--close-icon').click
        expect(page).to have_selector('.usa-modal--lg', visible: true)
        click_button('Continue editing')
        within(all('.practice-editor-origin-li').last) do
          find('.usa-combo-box__input').click
          find('.usa-combo-box__input').set('Caribou VA Clinic')
          all('.usa-combo-box__list-option').first.click
        end
        expect(page).to have_selector('.usa-modal--lg', visible: false)
        find('.dm-button--close-icon').click
        within(:css, '.usa-modal--lg') do
          find('#practice-editor-modal-save-button').click
        end
        expect(page).to have_current_path(practice_path(@unpublished_pr))
        expect(page).to have_content('This is a newly titled practice')
        expect(page).to have_content('Caribou VA Clinic')

        # exit without saving
        visit practice_overview_path(@unpublished_pr)
        fill_in('Problem statement', with: 'this is a fresh problem statement.')
        find('.dm-button--close-icon').click
        expect(page).to have_selector('.usa-modal--lg', visible: true)
        within(:css, '.usa-modal--lg') do
          find('.dm-button--unstyled-warning').click
        end
        expect(page).to have_selector('.show-main', visible: true)
        expect(page).to have_current_path(practice_path(@unpublished_pr))
        expect(page).to have_no_content('this is a fresh problem statement.')

        # close the modal
        visit practice_implementation_path(@unpublished_pr)
        find('.dm-button--close-icon').click
        expect(page).to have_selector('.usa-modal--lg', visible: true)
        find('.dm-modal-close-button').click
        expect(page).to have_selector('.usa-modal--lg', visible: false)
      end
    end
  end
end
