# frozen_string_literal: true

require 'rails_helper'
include ActiveAdminHelpers

describe 'Admin innovation views leaderboard', type: :feature do
  before do
    set_date_values
    @admin = User.create!(
      email: 'forger.loid@va.gov',
      password: 'Password123',
      password_confirmation: 'Password123',
      skip_va_validation: true,
      confirmed_at: Time.now,
      accepted_terms: true
    )
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @practice = Practice.create!(
      name: 'Some Awesome Practice',
      user: @admin,
      initiating_facility: 'Test facility name',
      tagline: 'Test tagline',
      published: true,
      approved: true,
      retired: false
    )
    @practice_2 = Practice.create!(
      name: 'An Interesting Practice',
      user: @admin,
      initiating_facility: 'Test facility name',
      tagline: 'Test tagline',
      published: true,
      approved: true,
      retired: false
    )
    @practice_3 = Practice.create!(
      name: 'A Fantastic Practice',
      user: @admin,
      initiating_facility: 'Test facility name',
      tagline: 'Test tagline',
      published: true,
      approved: true,
      retired: false
    )
    @ahoy_visit = Ahoy::Visit.create!(user_id: @admin.id, started_at: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice show', properties: { practice_id: @practice_2.id }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice show', properties: { practice_id: @practice_2.id }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice show', properties: { practice_id: @practice_2.id }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice show', properties: { practice_id: @practice.id }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice show', properties: { practice_id: @practice.id }, time: Time.now)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice show', properties: { practice_id: @practice_3.id }, time: Time.now - 2.months)
    Ahoy::Event.create!(visit_id: @ahoy_visit.id, name: 'Practice show', properties: { practice_id: @practice_3.id }, time: Time.now - 3.months)

    current_year = @beginning_of_current_month.year
    current_month = @beginning_of_current_month.strftime('%B').downcase
    is_month_one_of_first_3_months = current_month == 'january' || current_month == 'february' || current_month == 'march'

    @current_month_class = ".col-#{current_month}_#{current_year}_-_current_month"
    @last_month_class = ".col-#{@beginning_of_last_month.strftime('%B').downcase}_#{is_month_one_of_first_3_months ? current_year - 1 : current_year}_-_last_month"
    @two_months_ago_class = ".col-#{@beginning_of_two_months_ago.strftime('%B').downcase}_#{is_month_one_of_first_3_months ? current_year - 1 : current_year}_-_2_months_ago"
    @three_months_ago_class = ".col-#{@beginning_of_three_months_ago.strftime('%B').downcase}_#{is_month_one_of_first_3_months ? current_year - 1 : current_year}_-_3_months_ago"
    @all_time_class = '.col-total_lifetime_views'

    login_as(@admin, scope: :user, run_callbacks: false)
    visit '/admin/innovation_views_leaderboard'
  end

  it 'should display all published, enabled, and approved practices in order by the amount of page views they have in the current month' do
    # check the name column to make sure the practices are in the correct order
    expect(all('.col-name')[1]).to have_text(@practice_2.name)
    expect(all('.col-name')[2]).to have_text(@practice.name)
    expect(all('.col-name')[3]).to have_text(@practice_3.name)
  end

  it 'should display the practice page views for each practice for the following periods of time: current month, last month, two months ago, three months ago, and all-time' do
    ### views ###
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
    # months ago
    expect(all(@three_months_ago_class)[1]).to have_text('0')
    expect(all(@three_months_ago_class)[2]).to have_text('0')
    expect(all(@three_months_ago_class)[3]).to have_text('1')
    # all-time
    expect(all(@all_time_class)[1]).to have_text('3')
    expect(all(@all_time_class)[2]).to have_text('2')
    expect(all(@all_time_class)[3]).to have_text('2')
  end

  it 'should display the total page views for ALL practices combined for the following periods of time: current month, last month, two months ago, three months ago, and all-time' do
    within(all('tr').last) do
      expect(all('td')[1]).to have_text('5')
      expect(all('td')[2]).to have_text('0')
      expect(all('td')[3]).to have_text('1')
      expect(all('td')[4]).to have_text('1')
      expect(all('td')[5]).to have_text('7')
    end
  end

  describe 'Cached practices' do
    it 'Should reset if certain practice attributes have been updated' do
      cache_keys = Rails.cache.redis.keys
      expect(cache_keys).to include('published_enabled_approved_practices')
      @practice.update(name: 'Some Cool Practice')
      expect(cache_keys).not_to include("searchable_practices_json")
      visit '/admin/innovation_views_leaderboard'
      expect(cache_keys).to include('published_enabled_approved_practices')
    end
  end
end
