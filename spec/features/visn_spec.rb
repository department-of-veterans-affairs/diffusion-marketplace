require 'rails_helper'

describe 'VISN pages', type: :feature do
  before do
    @visn = Visn.create!(name: 'Test VISN', number: 2)
  end

  describe 'index page' do
    it 'should be there' do
      visit '/visns'
      expect(page).to have_current_path(visns_path)
    end
  end

  describe 'show page' do
    it 'should be there if the VISN number exists in the DB' do
      visit '/visns/2'
      expect(page).to have_current_path(visn_path(@visn))
    end
  end
end