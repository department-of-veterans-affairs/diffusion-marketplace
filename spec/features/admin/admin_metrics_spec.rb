require 'rails_helper'


describe 'Admin Dashboard Metrics Tab', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility: 'Test facility name', tagline: 'Test tagline', enabled: true, published: true, support_network_email: 'sandy.cheeks@bikinibottom.net')
    @page_group = PageGroup.create(name: 'programming', description: 'Pages about programming go in this group.')
    @page_group_1 = PageGroup.create(name: 'ghost_page', description: 'Pages should not be in the metrics')
    login_as(@admin, scope: :user, run_callbacks: false)
  end

  it 'favorite should display in last month but not in total if unfavorited' do
    user_practice_favorited = UserPractice.create(time_favorited: DateTime.now-1.months, user: @admin, practice: @practice, favorited: true)
    visit_metrics_tab
    within(:css, '#favorited_stats') do
      td_element = find('td[class*="last_month"]')
      expect(td_element.text).to eq('1')
      td_total = find('td[class*="total_favorited"]')
      expect(td_total.text).to eq('1')
    end
    user_practice_favorited.favorited = false
    user_practice_favorited.save
    visit_metrics_tab
    within(:css, '#favorited_stats') do
      td_element = find('td[class*="last_month"]')
      expect(td_element.text).to eq('1')
      td_total = find('td[class*="total_favorited"]')
      expect(td_total.text).to eq('0')
    end
  end

  it 'favorite should display in current month but not in total if unfavorited' do
   user_practice_favorited = UserPractice.create(time_favorited: DateTime.now, user: @admin, practice: @practice, favorited: true)
   visit_metrics_tab
   within(:css, '#favorited_stats') do
     td_element = find('td[class*="-_current_month"]')
     expect(td_element.text).to eq('1')
     td_total = find('td[class*="total_favorited"]')
     expect(td_total.text).to eq('1')
   end
   user_practice_favorited.favorited = false
   user_practice_favorited.save
   visit_metrics_tab
   within(:css, '#favorited_stats') do
     td_element = find('td[class*="-_current_month"]')
     expect(td_element.text).to eq('1')
     td_total = find('td[class*="total_favorited"]')
     expect(td_total.text).to eq('0')
   end
  end

  it 'should display at least one time_favorited' do
    UserPractice.create(time_favorited: DateTime.now - 1.months, user: @admin, practice: @practice, time_committed: DateTime.now - 1.months, committed: true)
    visit_metrics_tab
    within(:css, '#favorited_stats') do
      td_element = find('td[class*="last_month"')
      expect(td_element.text).to eq('1')
    end
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123',
                         password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    UserPractice.create(time_favorited: DateTime.now - 1.months, user: @admin, practice: @practice, time_committed: DateTime.now - 1.months, committed: true)
    visit_metrics_tab
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

    visit_metrics_tab
    check_counts(0)
    visit practice_path(@practice)
    within(:css, '#dm-practice-nav') do
      find('.dm-email-practice').click
    end
    visit_metrics_tab
    check_counts(1)
    visit practice_path(@practice)
    within(:css, '.main-email-address-container') do
      find('.dm-email-practice').click
    end
    visit_metrics_tab
    check_counts(2)
  end

  it 'should update the custom page view counts' do
    Page.create!(title: 'Test', description: 'This is a test page', slug: 'home', page_group: @page_group)

    visit_metrics_tab
    expect(page).to have_no_content(@page_group_1.name)
    expect(page).to have_link(href: '/programming')
    within(:css, '#dm-custom-page-traffic') do
      td_unique = find('td[class*="total_views_custom_page"]')
      expect(td_unique.text).to eq("0")
    end
    visit '/programming'
    visit_metrics_tab
    within(:css, '#dm-custom-page-traffic') do
      td_unique = find('td[class*="total_views_custom_page"]')
      expect(td_unique.text).to eq("1")
    end
  end

  it 'should not display the custom page view section if there are no page groups with homepages' do
    visit_metrics_tab
    expect(page).to have_no_content("Custom Page Traffic")
    expect(page).to have_no_link(href: '/programming')
  end

  def visit_metrics_tab
    visit '/admin'
    click_link 'Metrics'
  end
end
