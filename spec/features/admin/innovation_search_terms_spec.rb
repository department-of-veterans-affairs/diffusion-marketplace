# frozen_string_literal: true

require 'rails_helper'
include ActiveAdminHelpers

describe 'Admin innovation search terms', type: :feature do
  before do
    set_date_values
    @admin = User.create!(
      email: 'briar.yor@va.gov',
      password: 'Password123',
      password_confirmation: 'Password123',
      skip_va_validation: true,
      confirmed_at: Time.now,
      accepted_terms: true
    )
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @ahoy_visit = Ahoy::Visit.create!(user_id: @admin.id, started_at: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice search', properties: { search_term: 'hello world' }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice search', properties: { search_term: 'hello world' }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice search', properties: { search_term: 'hello world' }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice search', properties: { search_term: 'foo' }, time: Time.now - 2.months)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice search', properties: { search_term: 'bar' }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice search', properties: { search_term: 'bar' }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'VISN practice search', properties: { search_term: 'hello world' }, time: Time.now - 3.months)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Facility practice search', properties: { search_term: 'bang' }, time: Time.now)

    current_year = @beginning_of_current_month.year

    @current_month_class = ".col-#{@beginning_of_current_month.strftime('%B').downcase}_#{current_year}_-_current_month"
    @last_month_class = ".col-#{@beginning_of_last_month.strftime('%B').downcase}_#{current_year}_-_last_month"
    @two_months_ago_class = ".col-#{@beginning_of_two_months_ago.strftime('%B').downcase}_#{current_year}_-_2_months_ago"
    @three_months_ago_class = ".col-#{@beginning_of_three_months_ago.strftime('%B').downcase}_#{current_year}_-_3_months_ago"
    @all_time_class = '.col-lifetime'

    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin/innovation_search_terms'
  end

  it 'should have a section for total search term counts and then counts based on which area the search was made from' do
    expect(page).to have_content('Total search counts')
    expect(page).to have_content('General search')
    expect(page).to have_content('VISN search')
    expect(page).to have_content('Facility search')
  end

  it 'should display the search terms and counts for all three search areas (ordered by most times searched) for the following
      periods of time: current month, last month, two months ago, three months ago, and all-time' do
    # general search
    within(:css, '#general-practice-search-terms-table') do
      # terms
      expect(all('.col-term')[1]).to have_text('hello world')
      expect(all('.col-term')[2]).to have_text('bar')
      expect(all('.col-term')[3]).to have_text('foo')
      ### counts ###
      # current month
      expect(all(@current_month_class)[1]).to have_text('3')
      expect(all(@current_month_class)[2]).to have_text('2')
      expect(all(@current_month_class)[3]).to have_text('0')
      # last month
      expect(all(@last_month_class)[1]).to have_text('0')
      expect(all(@last_month_class)[2]).to have_text('0')
      expect(all(@last_month_class)[3]).to have_text('0')
      # two months ago
      expect(all(@two_months_ago_class)[1]).to have_text('0')
      expect(all(@two_months_ago_class)[2]).to have_text('0')
      expect(all(@two_months_ago_class)[3]).to have_text('1')
      # three months ago
      expect(all(@three_months_ago_class)[1]).to have_text('0')
      expect(all(@three_months_ago_class)[2]).to have_text('0')
      expect(all(@three_months_ago_class)[3]).to have_text('0')
      # all-time
      expect(all(@all_time_class)[1]).to have_text('3')
      expect(all(@all_time_class)[2]).to have_text('2')
      expect(all(@all_time_class)[3]).to have_text('1')
    end
    # VISN search
    within(:css, '#visn-practice-search-terms-table') do
      expect(all('.col-term')[1]).to have_text('hello world')
      ### counts ###
      # current month
      expect(all(@current_month_class)[1]).to have_text('0')
      # last month
      expect(all(@last_month_class)[1]).to have_text('0')
      # two months ago
      expect(all(@two_months_ago_class)[1]).to have_text('0')
      # three months ago
      expect(all(@three_months_ago_class)[1]).to have_text('1')
      # all-time
      expect(all(@all_time_class)[1]).to have_text('1')
    end
    # facility search
    within(:css, '#facility-practice-search-terms-table') do
      expect(all('.col-term')[1]).to have_text('bang')
      ### counts ###
      # current month
      expect(all(@current_month_class)[1]).to have_text('1')
      # last month
      expect(all(@last_month_class)[1]).to have_text('0')
      # two months ago
      expect(all(@two_months_ago_class)[1]).to have_text('0')
      # three months ago
      expect(all(@three_months_ago_class)[1]).to have_text('0')
      # all-time
      expect(all(@all_time_class)[1]).to have_text('1')
    end
  end

  it 'should display the total search term counts for each area at the bottom of each area\'s table' do
    # general search totals
    within(:css, '#general-practice-search-terms-table') do
      within(all('tr').last) do
        expect(all('td')[1]).to have_text('5')
        expect(all('td')[2]).to have_text('0')
        expect(all('td')[3]).to have_text('1')
        expect(all('td')[4]).to have_text('0')
        expect(all('td')[5]).to have_text('6')
      end
    end

    # VISN search totals
    within(:css, '#visn-practice-search-terms-table') do
      within(all('tr').last) do
        expect(all('td')[1]).to have_text('0')
        expect(all('td')[2]).to have_text('0')
        expect(all('td')[3]).to have_text('0')
        expect(all('td')[4]).to have_text('1')
        expect(all('td')[5]).to have_text('1')
      end
    end

    # facility search totals
    within(:css, '#facility-practice-search-terms-table') do
      within(all('tr').last) do
        expect(all('td')[1]).to have_text('1')
        expect(all('td')[2]).to have_text('0')
        expect(all('td')[3]).to have_text('0')
        expect(all('td')[4]).to have_text('0')
        expect(all('td')[5]).to have_text('1')
      end
    end
  end
end