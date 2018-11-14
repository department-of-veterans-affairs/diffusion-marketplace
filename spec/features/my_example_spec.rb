require 'rails_helper'

describe 'My behaviour', type: :feature do

  it 'should do something' do
    visit '/'
    expect(page).to have_content('Diffusion Marketplace')
  end
end