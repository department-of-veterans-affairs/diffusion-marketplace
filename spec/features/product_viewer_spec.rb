require 'rails_helper'

describe 'Product show page', type: :feature do
  let!(:product) { create(:product)}
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin)}

  it 'hides unpublished pages' do
    visit product_path(product)
    expect(page).not_to have_content product.name
    expect(page).to have_current_path(root_path)
    login_as(admin, :scope => :user, :run_callbacks => false)
    visit product_path(product)
    expect(page).to have_content('Unpublished')
    expect(page).to have_content product.name
    expect(page).to have_current_path(product_path(product))
  end

  it 'has human-readable URLs' do
    product.update(published: true)
    visit "/products/#{product.name.parameterize}"
    expect(page).to have_current_path(product_path(product))
  end
end
