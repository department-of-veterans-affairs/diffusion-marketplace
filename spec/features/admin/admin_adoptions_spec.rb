require 'rails_helper'

describe 'Admin Adoptions Tab', type: :feature do
  before do
    @admin = User.create!(email: 'dokugamine.riruka@execution.com', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @practice = Practice.create!(name: 'The Best Practice Ever!', user: @user, initiating_facility_type: 'facility', initiating_facility: '678GC', tagline: 'Test tagline')
    login_as(@admin, scope: :user, run_callbacks: false)
    @diffusion_history = DiffusionHistory.create!(practice_id: @practice.id, facility_id: '600GC')
    @diffusion_history_2 = DiffusionHistory.create!(practice_id: @practice.id, facility_id: '516')
    @diffusion_history_3 = DiffusionHistory.create!(practice_id: @practice.id, facility_id: '649GD', created_at: Date.today - 1.months)
    @diffusion_history_status = DiffusionHistoryStatus.create!(diffusion_history_id: @diffusion_history.id, status: 'In progress')
    @diffusion_history_status_2 = DiffusionHistoryStatus.create!(diffusion_history_id: @diffusion_history_2.id, status: 'Unsuccessful')
    @diffusion_history_status_3 = DiffusionHistoryStatus.create!(diffusion_history_id: @diffusion_history_3.id, status: 'Successful')
  end

  it 'should show all adoptions and adoption counts for practices that have at least one adoption' do
    visit '/admin'
    click_link 'Adoptions'

    expect(page).to have_selector("input[value='Download All']")
    expect(page).to have_selector('.panel', count: 2)
    expect(page).to have_content('CURRENT MONTH')
    expect(page).to have_content('LAST MONTH')
    expect(page).to have_content('2 MONTHS AGO')
    expect(page).to have_content('CURRENT TOTAL')
    expect(page).to have_content('The Best Practice Ever!')
    expect(page).to have_content('Cabrillo VA Clinic')
    expect(page).to have_content('C.W. Bill Young Department of Veterans Affairs Medical Center (Bay Pines)')
  end

  it 'should show the total adoptions for all practices and adoptions made within a 3-month interval(current month, one month ago, two months ago)' do
    visit '/admin'
    click_link 'Adoptions'

    expect(page).to have_content('All adoptions')
    within(:css, '.all-adoptions-columns') do
      current_month_el = all(".all-adoptions-current-month").last
      last_month_el = all(".all-adoptions-last-month").last
      two_months_ago_el = all(".all-adoptions-two-months-ago").last
      total_el = all(".all-adoptions-total").last

      expect(current_month_el.text).to eq('2')
      expect(last_month_el.text).to eq('1')
      expect(two_months_ago_el.text).to eq('0')
      expect(total_el.text).to eq('3')
    end
  end

  it 'should allow an admin to download adoption data as a .xlsx file' do
    visit '/admin'
    click_link 'Adoptions'
    export_button = find(:css, "input[type='submit']")
    export_button.click

    # should not navigate away from metrics page
    expect(page).to have_current_path(admin_adoptions_path)
  end
end