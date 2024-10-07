require 'rails_helper'

describe 'Product editor - Editors', type: :feature do
  let!(:product) { create(:product)}
  let!(:user) { create(:user) } 
  let!(:admin) { create(:user, :admin)}

  before do
    login_as(current_user, :scope => :user, :run_callbacks => false)
  end

  describe 'when logged in as a regular user' do
    let(:current_user) { user }

    context 'with no permissions' do
      it 'redirects to the root path with a warning' do
        visit product_editors_path(product)
        expect(page).to have_current_path('/')
        expect(page).to have_content('You are not authorized to view this content.')
      end
    end
  end

  describe 'when logged in as an admin' do
    let(:current_user) { admin }

    it 'allows access and displays the product description form' do
      visit product_editors_path(product)
      expect(page).to have_selector('h1', text:'Editors')
    end
  end

  describe 'when not logged in' do
    let(:current_user) { nil }

    context 'without login' do
      it 'redirects to the login page' do
        visit product_editors_path(product)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
