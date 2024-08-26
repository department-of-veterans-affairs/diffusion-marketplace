require 'rails_helper'

describe 'Page Builder', type: :feature do
  before do
    @admin = create(:user, :admin, email: 'sandy.cheeks@va.gov')
    @image_file = "#{Rails.root}/spec/assets/charmander.png"
    login_as(@admin, scope: :user, run_callbacks: false)
  end

  describe 'Validations' do
  end

  describe 'Publishing' do
  	it 'warns the user about unpublishing the homepage' do
  	end

  	it 'prevents the user from deleting the current homepage' do
  	end

  	it 'uses hardcoded backfill content when no homepage is available' do # remove this after the first homepage is created
  	end

  	it 'unpublishes the current homepage when publishing a new page' do
  	end
  end

  describe 'creating the page' do
  	it 'publishes section titles' do
  	end
  	it 'creates homepage features' do
  	end

  	it 'renders a maximum of 3 items per section' do
  	end
  	it 'adjusts column sizes' do
  	end
  end



end