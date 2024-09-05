require 'rails_helper'

RSpec.feature "Admin::Products", type: :feature do
  let(:admin_user) { create(:user, :admin) }

  before do
    login_as(admin_user, scope: :user)
  end

  scenario "Admin creates a product successfully" do
    visit new_admin_product_path

    fill_in "Product name *Required*", with: "Test Product"
    fill_in "User email", with: "testuser@va.gov"

    click_button "Create Product"

    expect(page).to have_content("Product was successfully created")
    expect(page).to have_content("Test Product")
    expect(page).to have_content("testuser@va.gov")
  end

  scenario "Admin creates a product and adds another" do
    visit new_admin_product_path

    fill_in "Product name *Required*", with: "First Product"
    fill_in "User email", with: "user@va.gov"

    check "create_another"

    click_button "Create Product"

    expect(page).to have_content("Product was successfully created. You can create another one.")
    expect(current_path).to eq(new_admin_product_path)
    expect(page).not_to have_field("Product name *Required*", with: "First Product")
  end

  scenario "Admin updates a product successfully" do
    product = create(:product, name: "Old Product", user: create(:user, email: "olduser@va.gov"))

    visit edit_admin_product_path(product)

    fill_in "Product name *Required*", with: "Updated Product"
    fill_in "User email", with: "newuser@va.gov"

    click_button "Update Product"

    expect(page).to have_content("Product was successfully updated")
    expect(page).to have_content("Updated Product")
    expect(page).to have_content("newuser@va.gov")
  end

  scenario "Admin tries to create a product with an invalid email" do
    visit new_admin_product_path

    fill_in "Product name *Required*", with: "Invalid Email Product"
    fill_in "User email", with: "invalidemail.com"

    click_button "Create Product"

    expect(page).to have_content("There was an error. Email must be a valid @va.gov address.")
    expect(current_path).to eq(new_admin_product_path)
  end

  scenario "Admin creates a product and automatically creates a new user if email does not exist" do
    visit new_admin_product_path

    fill_in "Product name *Required*", with: "Product with New User"
    fill_in "User email", with: "newuser@va.gov"

    click_button "Create Product"

    expect(page).to have_content("Product was successfully created")
    expect(page).to have_content("Product with New User")
    expect(page).to have_content("newuser@va.gov")

    expect(User.find_by(email: "newuser@va.gov")).not_to be_nil
  end
end
