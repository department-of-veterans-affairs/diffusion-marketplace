require 'rails_helper'
describe 'Strategic sponsors pages', type: :feature do
  it 'should navigate to strategic sponsors list page', js: true do
    visit '/'
    find(:css, 'a', text: 'Practice Partners').click
    expect(current_path).to eq('/strategic_sponsors')
  end

  it 'should be 508 compliant' do
    visit '/strategic_sponsors'
  end
end