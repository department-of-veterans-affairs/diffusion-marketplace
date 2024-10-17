require 'rails_helper'

describe 'Product show page', type: :feature do
  let!(:product) { create(:product, :with_partners)}
  let(:product_with_images) { create(:product, :with_image, :with_multimedia, name: 'Product with Images', published: true) }
  let(:product_with_tags) { create(:product, :with_tags, published: true) }
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

  it 'conditionally renders text fields' do
    login_as(admin, :scope => :user, :run_callbacks => false)
    visit product_path(product)
    expect(page).to have_content 'Executive Summary'
    expect(page).to have_content 'Item Number'
    expect(page).to have_content 'Vendor'
    expect(page).to have_content 'DUNS'
    expect(page).to have_content 'Partners'
    expect(page).to have_content 'Shipping Timeline Estimate'
    expect(page).to have_content 'Price'
    product.update(vendor: nil)
    visit product_path(product)
    expect(page).to have_no_selector('h3', text: 'Vendor')
  end

  it 'conditionally renders linked fields ' do
    login_as(admin, :scope => :user, :run_callbacks => false)
    visit product_path(product)
    expect(page).to have_link(product.vendor)
    product.update(vendor_link: nil)
    visit product_path(product)
    expect(page).not_to have_link(product.vendor)
  end

  it 'renders media assets' do
    visit(product_path(product_with_images))
    expect(page).to have_css('.product-main-display-image')
    expect(page).to have_content('sample image caption')
    within('.multimedia-section') do
      expect(page).to have_css('.practice-editor-impact-photo')
      expect(page).to have_css('.video-container')
    end
  end

  it 'renders associated categories / tags', js: true do
    visit(product_path(product_with_tags))
    within('#show-page-siderail') do
      expect(page).to have_css('.show-page-tag', count: 10)
      expect(page).to have_content(/See more/i)
    end
  end
end
