require 'rails_helper'
describe 'Practice partners pages', type: :feature do
  it 'should navigate to strategic sponsors list page' do
    visit '/'
    find(:css, 'a', text: 'Practice Partners').click
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(current_path).to eq('/practice_partners')
  end
end