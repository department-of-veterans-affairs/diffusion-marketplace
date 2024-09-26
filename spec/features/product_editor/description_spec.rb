require 'rails_helper'

describe 'Product editor - description', type: :feature do
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
        visit product_description_path(product)
        expect(page).to have_current_path('/')
        expect(page).to have_content('You are not authorized to view this content.')
      end
    end
  end

  describe 'when logged in as an admin' do
    let(:current_user) { admin }

    it 'allows access and displays the product description form' do
      visit product_description_path(product)
      expect(page).to have_content('Description')
      expect(page).to have_field('product_name', with: product.name)
    end

    it 'allows access to the description page and updates the product successfully' do
      visit product_description_path(product)
      expect(page).to have_content('Description')

      fill_in 'product_name', with: 'Updated Product Name'
      click_button 'Submit'

      expect(page).to have_content('Product was successfully updated.')
      expect(product.reload.name).to eq('Updated Product Name')
    end

    it 'shows validation errors for missing required fields' do
      visit product_description_path(product)

      fill_in 'product_name', with: ''
      click_button 'Submit'
      expect(page).to have_current_path(product_description_path(product))
      expect(page).to have_selector("input:invalid")
    end

    it 'shows model validation errors' do
      new_product = create(:product, name: 'more different name')
      visit product_description_path(new_product)

      fill_in 'product_name', with: product.name
      click_button 'Submit'
      expect(page).to have_current_path(product_description_path(new_product))
      expect(page).to have_content('Product name already exists')
    end

    it 'allows product categories to be updated' do
      parent_cat1 = create(:category, name: "clinical")
      cat1 = create(:category, name: "Test Category 1", parent_category: parent_cat1)
      cat2 = create(:category, name: "Test Category 2", parent_category: parent_cat1)
      create(:category_practice, innovable: product, category: cat1)

      visit product_description_path(product)
      within(:css, '.dm-clinical-category-columns-container') do
        expect(find("#cat-2-input", visible: false)).to be_checked
        expect(find("#cat-3-input", visible: false)).to_not be_checked
        expect(find("#cat-all-clinical-input", visible: false)).to_not be_checked
        find('.usa-checkbox__label[title="Test Category 2"]').click
        expect(find("#cat-all-clinical-input", visible: false)).to be_checked
      end
      click_button 'Submit'

      expect(product.categories).to include(cat1, cat2)

      visit product_description_path(product)
      within(:css, '.dm-clinical-category-columns-container') do
        expect(find("#cat-2-input", visible: false)).to be_checked
        expect(find("#cat-3-input", visible: false)).to be_checked
        expect(find("#cat-all-clinical-input", visible: false)).to be_checked
        find('.usa-checkbox__label[title="Test Category 1"]').click
        expect(find("#cat-2-input", visible: false)).to_not be_checked
        expect(find("#cat-3-input", visible: false)).to be_checked
        expect(find("#cat-all-clinical-input", visible: false)).to_not be_checked
      end
      click_button 'Submit'

      expect(product.categories).to include(cat2)
      expect(product.categories).to_not include(cat1)
    end
  end

  describe 'when not logged in' do
    let(:current_user) { nil }

    context 'without login' do
      it 'redirects to the login page' do
        visit product_description_path(product)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
