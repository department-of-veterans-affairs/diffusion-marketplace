require 'rails_helper'

describe 'Practices', type: :feature do
  before do
    @user = User.create!(email: 'spongebob.squarepants@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @user2 = User.create!(email: 'patrick.star@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @approver = User.create!(email: 'squidward.tentacles@bikinibottom.net', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now)
    @admin.add_role(User::USER_ROLES[1].to_sym)
    @approver.add_role(User::USER_ROLES[0].to_sym)
    @user_practice = Practice.create!(name: 'The Best Practice Ever!', user: @user)
  end

  it 'should not let unauthenticated users interact with practices' do
    # Visit an individual Practice
    visit '/practices/1'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_current_path('/users/sign_in')

    # Visit the Marketplace
    visit '/practices'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_current_path('/users/sign_in')
  end

  it 'should let authenticated users interact with the marketplace' do
    login_as(@user, :scope => :user, :run_callbacks => false)

    # Visit an individual Practice that is approved and published
    practice = Practice.create!(name: 'A public practice', approved: true, published: true)
    visit practice_path(practice)
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content(practice.name)
    expect(page).to have_current_path(practice_path(practice))

    # Visit the Marketplace
    visit '/practices'
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content(practice.name)
  end

  it 'should let the practice owner interact with their practice if not approved or published' do
    login_as(@user, :scope => :user, :run_callbacks => false)

    # Visit user's own practice that is not approved or published
    visit practice_path(@user_practice)
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content(@user_practice.name)
    expect(page).to have_current_path(practice_path(@user_practice))
  end

  it 'should not let a user view the practice if the practice is not approved or published' do
    login_as(@user2, :scope => :user, :run_callbacks => false)
    # Visit a user's practice that is not approved or published
    visit practice_path(@user_practice)
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Saving lives by diffusing best practices')
    expect(page).to have_current_path('/')
  end

  it 'should let an approver/editor user view the practice if the practice is not approved or published' do
    login_as(@approver, :scope => :user, :run_callbacks => false)

    # Visit a user's practice that is not approved or published
    visit practice_path(@user_practice)
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content(@user_practice.name)
    expect(page).to have_current_path(practice_path(@user_practice))
  end

  it 'should let an admin user view the practice if the practice is not approved or published' do
    login_as(@admin, :scope => :user, :run_callbacks => false)

    # Visit a user's practice that is not approved or published
    visit practice_path(@user_practice)
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content(@user_practice.name)
    expect(page).to have_current_path(practice_path(@user_practice))
  end

end