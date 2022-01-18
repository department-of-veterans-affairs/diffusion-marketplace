require 'rails_helper'
require 'spec_helper'

describe 'show page' do
  it 'should be there if the VISN number exists in the DB' do
    visit '/crh/1'
    expect(page).to have_content("Department of Veterans Affairs")
  end

  it 'should throw error if VISN number does not exist in the DB' do
    visit '/crh/50'
    expect(page).to have_content("Couldn't find Visn")
  end
end