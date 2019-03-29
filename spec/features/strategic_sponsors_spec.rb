require 'rails_helper'
describe 'Strategic sponsors pages', type: :feature do
  it 'should navigate to strategic sponsors list page' do
    visit '/'
    click_link 'Practice Partners'
    expect(current_path).to eq('/strategic_sponsors')
  end
end