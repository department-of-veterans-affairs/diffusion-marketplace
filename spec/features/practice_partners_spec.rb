require 'rails_helper'
describe 'Practice partners pages', type: :feature do
  it 'should navigate to strategic sponsors list page', js: true do
    visit '/'
    find(:css, 'a', text: 'Practice Partners').click
    expect(current_path).to eq('/practice_partners')
  end

  it 'should be 508 compliant' do
    visit '/practice_partners'
  end
end