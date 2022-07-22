# frozen_string_literal: true

require 'rails_helper'

describe 'Admin site metrics', type: :feature do
  before do
    @admin = User.create!(
      email: 'kyojuro.rengoku@va.gov',
      password: 'Password123',
      password_confirmation: 'Password123',
      skip_va_validation: true,
      confirmed_at: Time.now,
      accepted_terms: true
    )
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @practice = Practice.create!(
      name: 'The Best Practice Ever!',
      user: @admin,
      initiating_facility: 'Test facility name',
      tagline: 'Test tagline',
      published: true,
      approved: true,
      retired: false,
      support_network_email: @admin.email
    )
    @page_group = PageGroup.create(name: 'Awesome Page Group', description: 'A page group containing awesome pages.', slug: 'awesome-page-group')
    Page.create!(title: 'Awesome Page', description: 'This is an awesome page', slug: 'awesome-page', page_group: @page_group)
    UserPractice.create!(practice: @practice, user: @admin, favorited: true, time_favorited: Time.now)
    @ahoy_visit = Ahoy::Visit.create!(user_id: @admin.id, started_at: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice email', properties: { practice_id: @practice.id }, time: Time.now)

    @current_month_class = ".col-#{Date.today.strftime('%B').downcase}_#{Date.today.year}_-_current_month"

    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin/site_metrics'
  end

  after(:all) do
    # remove .xlsx file download
    FileUtils.rm_rf("#{Rails.root}/tmp/downloads")
  end

  def assert_stat_text(current_month_text, last_month_text, total_class, total_text)
    expect(all(@current_month_class)[1]).to have_text(current_month_text)
    expect(all('.col-last_month')[1]).to have_text(last_month_text)
    expect(all(total_class)[1]).to have_text(total_text)
  end

  it "should have three content tabs: 'General, 'Innovation Engagement', and 'Users'" do
    within(:css, '.nav-tabs') do
      expect(page).to have_link('General', href: '#general')
      expect(page).to have_link('Innovation Engagement', href: '#innovation-engagement')
      expect(page).to have_link('Users', href: '#users-tab')
    end
  end

  context 'General tab' do
    it 'should display information about site traffic and created practices' do
      visit '/awesome-page-group/awesome-page'
      visit '/admin/site_metrics'

      # General Traffic
      expect(all('.col-unique_visitors_last_month')[1]).to have_text('0')
      expect(all('.col-number_of_page_views_last_month')[1]).to have_text('0')
      expect(all('.col-total_accounts_all-time')[1]).to have_text('1')

      # Custom Page Traffic
      expect(all('.col-page')[1]).to have_link('awesome-page-group/awesome-page')
      expect(all('.col-unique_visitors_custom_page')[1]).to have_text('0')
      expect(all('.col-page_views_custom_page')[1]).to have_text('0')
      expect(all('.col-total_views_custom_page')[1]).to have_text('1')

      # Innovations Created
      expect(all(@current_month_class)[1]).to have_text('1')
      expect(all('.col-last_month')[1]).to have_text('0')
      expect(all('.col-total_innovations_created')[1]).to have_text('1')
    end

    it 'should update the custom page view counts' do
      @page_group = PageGroup.create(name: 'programming', description: 'Pages about programming go in this group.')
      @page_group_1 = PageGroup.create(name: 'ghost_page', description: 'Pages should not be in the metrics')
      Page.create!(title: 'Test', description: 'This is a test page', slug: 'home', page_group: @page_group)

      visit '/admin'
      expect(page).to have_no_content(@page_group_1.name)
      expect(page).to have_link(href: '/programming')
      within(:css, '#dm-custom-page-traffic') do
        td_unique = all('td[class*="total_views_custom_page"]')[1]
        expect(td_unique.text).to eq('0')
      end
      visit '/programming'
      visit '/admin'
      within(:css, '#dm-custom-page-traffic') do
        td_unique = all('td[class*="total_views_custom_page"]')[1]
        expect(td_unique.text).to eq('1')
      end
    end

    it 'should not display the custom page view section if there are no page groups with homepages' do
      PageGroup.destroy_all
      visit '/admin'
      expect(page).to have_no_content('Custom Page Traffic')
      expect(page).to have_no_link(href: '/programming')
    end
  end

  context 'Innovation engagement tab' do
    it 'should display information about practice engagement' do
      click_link('Innovation Engagement')
      expect(page).to have_content('Bookmarks')
      expect(page).to have_content('Comments')
      expect(page).to have_content('Emails')
      # Bookmarks
      within(:css, '#favorited_stats') do
        assert_stat_text('1', '0', '.col-total_favorited', '1')
      end

      within(:css, '#favorited-stats-by-practice') do
        expect(all('.col-name')[1]).to have_link(@practice.name)
        assert_stat_text('1', '0', '.col-current_total', '1')
      end
      # Comments
      within(:css, '#comment-stats') do
        assert_stat_text('0', '0', '.col-total_comments', '0')
      end
      # Emails
      within(:css, '#dm-practices-emailed-total') do
        assert_stat_text('1', '0', '.col-total_emails', '1')
      end

      within(:css, '#dm-practices-emailed-by-practice') do
        expect(all('.col-name')[1]).to have_link(@practice.name)
        assert_stat_text('1', '0', '.col-current_total', '1')
      end
    end

    it 'favorite should display in last month but not in total if unfavorited' do
      user_practice_favorited = UserPractice.create(time_favorited: DateTime.now - 1.months, user: @admin, practice: @practice, favorited: true)
      visit '/admin'
      click_link('Innovation Engagement')

      within(:css, '#favorited_stats') do
        td_element = find('td[class*="last_month"]')
        expect(td_element.text).to eq('1')
        td_total = find('td[class*="total_favorited"]')
        expect(td_total.text).to eq('2')
      end

      user_practice_favorited.favorited = false
      user_practice_favorited.save
      visit '/admin'
      click_link('Innovation Engagement')

      within(:css, '#favorited_stats') do
        td_element = find('td[class*="last_month"]')
        expect(td_element.text).to eq('1')
        td_total = find('td[class*="total_favorited"]')
        expect(td_total.text).to eq('1')
      end
    end

    it 'favorite should display in current month but not in total if unfavorited' do
      user_practice_favorited = UserPractice.create(time_favorited: DateTime.now, user: @admin, practice: @practice, favorited: true)
      visit '/admin'
      click_link('Innovation Engagement')

      within(:css, '#favorited_stats') do
        td_element = find('td[class*="-_current_month"]')
        expect(td_element.text).to eq('2')
        td_total = find('td[class*="total_favorited"]')
        expect(td_total.text).to eq('2')
      end

      user_practice_favorited.favorited = false
      user_practice_favorited.save
      visit '/admin'
      click_link('Innovation Engagement')

      within(:css, '#favorited_stats') do
        td_element = find('td[class*="-_current_month"]')
        expect(td_element.text).to eq('2')
        td_total = find('td[class*="total_favorited"]')
        expect(td_total.text).to eq('1')
      end
    end

    it 'should display at least one time_favorited' do
      UserPractice.create(time_favorited: DateTime.now - 1.months, user: @admin, practice: @practice, time_committed: DateTime.now - 1.months, committed: true)
      visit '/admin'
      click_link('Innovation Engagement')

      within(:css, '#favorited_stats') do
        td_element = find('td[class*="last_month"')
        expect(td_element.text).to eq('1')
      end

      UserPractice.create(time_favorited: DateTime.now - 1.months, user: @admin, practice: @practice, time_committed: DateTime.now - 1.months, committed: true)
      visit '/admin'
      click_link('Innovation Engagement')

      within(:css, '#favorited_stats') do
        td_element = find('td[class*="last_month"')
        expect(td_element.text).to eq('2')
      end
    end

    it 'should update the Practice Email count' do
      def check_counts(val)
        within(:css, '#dm-practices-emailed-total') do
          td_current = find('td[class*="current_month"')
          expect(td_current.text).to eq(val.to_s)
          td_total = find('td[class*="total_emails"]')
          expect(td_total.text).to eq(val.to_s)
        end
        within(:css, '#dm-practices-emailed-by-practice') do
          td_current = find('td[class*="current_month"')
          expect(td_current.text).to eq(val.to_s)
          td_total = find('td[class*="current_total"]')
          expect(td_total.text).to eq(val.to_s)
        end
      end

      visit '/admin'
      click_link('Innovation Engagement')
      check_counts(1)
      visit practice_path(@practice)
      within(:css, '#dm-practice-nav') do
        find('.dm-email-practice').click
      end
      visit '/admin'
      click_link('Innovation Engagement')
      check_counts(2)
      visit practice_path(@practice)
      within(:css, '.main-email-address-container') do
        find('.dm-email-practice').click
      end
      visit '/admin'
      click_link('Innovation Engagement')
      check_counts(3)
    end
  end

  context 'Users tab' do
    it 'should display information about users' do
      visit root_path
      visit '/admin/site_metrics'
      within(:css, '#main_content') do
        click_link('Users')
      end
      expect(page).to have_content('New Users by Month')
      expect(page).to have_content('Unique User Visits by Month')

      within(:css, '#user-stats-panel') do
        # New users
        expect(all('.col-in_the_last')[1]).to have_text('New Users')
        expect(all('.col-24_hours')[1]).to have_text('1')
        expect(all('.col-week')[1]).to have_text('1')
        expect(all('.col-month')[1]).to have_text('1')
        expect(all('.col-three_months')[1]).to have_text('1')
        expect(all('.col-year')[1]).to have_text('1')
        # Unique user visits
        expect(all('.col-in_the_last')[2]).to have_text('Unique User Visits')
        expect(all('.col-24_hours')[2]).to have_text('1')
        expect(all('.col-week')[2]).to have_text('1')
        expect(all('.col-month')[2]).to have_text('1')
        expect(all('.col-three_months')[2]).to have_text('1')
        expect(all('.col-year')[2]).to have_text('1')
      end
    end
  end

  it 'should show allow admin to download metrics as .xlsx file' do
    export_button = find(:css, "input[type='submit']")
    export_button.click

    # should not navigate away from metrics page
    expect(page).to have_current_path(admin_site_metrics_path)
  end

  describe 'Cached practices' do
    it 'Should reset if certain practice attributes have been updated' do
      cache_keys = Rails.cache.redis.keys
      expect(cache_keys).to include('published_enabled_approved_practices')
      @practice.update(name: 'The Coolest Practice Ever!')
      expect(cache_keys).not_to include("searchable_practices_json")
      visit '/admin'
      expect(cache_keys).to include('published_enabled_approved_practices')
    end
  end
end