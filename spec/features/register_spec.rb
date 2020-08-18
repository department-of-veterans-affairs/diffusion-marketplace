require 'rails_helper'

describe 'Register', type: :feature do
  it 'should not let the user sign up with a weak password or without a va.gov email address' do

    visit '/'
    expect(page).to have_content('Diffusion Marketplace')

    click_on('Sign in')
    click_on('Register')
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(current_path).to eq('/users/sign_up')
    expect(page).to have_content('Register')


    fill_in('Email', with: 'test@agile6')
    fill_in('Password', with: 'Passwrrd')
    fill_in('Password confirmation', with: 'Passwrrd')
    click_button('Register')

    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Email must use @va.gov email address')
    expect(page).to have_content('Email invalid')
    expect(page).to have_content('Password must include 6 unique characters')
    expect(page).to have_content('Password complexity requirement not met. Password must include 3 of the following: 1 uppercase, 1 lowercase, 1 digit and 1 special character')
  end
end