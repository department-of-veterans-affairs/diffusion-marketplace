require 'rails_helper'

RSpec.feature "Admin::Products", type: :feature do
  let(:admin_user) { create(:user, :admin) }

  before do
    login_as(admin_user, scope: :user)
  end

  describe "Creating a product" do
    context "with valid attributes" do
      scenario "creates a product successfully" do
        visit new_admin_product_path

        fill_in "Product name *Required*", with: "Test Product"
        fill_in "User email", with: "testuser@va.gov"

        click_button "Create Product"

        expect(page).to have_content("Product was successfully created")
        expect(page).to have_content("Test Product")
        expect(page).to have_content("testuser@va.gov")
      end

      scenario "creates a product and adds another" do
        visit new_admin_product_path

        fill_in "Product name *Required*", with: "First Product"
        fill_in "User email", with: "user@va.gov"
        check "create_another"

        click_button "Create Product"

        expect(page).to have_content("Product was successfully created. You can create another one.")
        expect(current_path).to eq(new_admin_product_path)
        expect(page).not_to have_field("Product name *Required*", with: "First Product")
      end

      scenario "automatically creates a new user if email does not exist" do
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

    context "with invalid attributes" do
      scenario "tries to create a product with an invalid email" do
        visit new_admin_product_path

        fill_in "Product name *Required*", with: "Invalid Email Product"
        fill_in "User email", with: "invalidemail.com"

        click_button "Create Product"

        expect(page).to have_content("Email must be a valid @va.gov address")
        expect(current_path).to eq(new_admin_product_path)

        expect(Product.find_by(name: "Invalid Email Product")).to be_nil
      end

      scenario "tries to create a product with a taken name" do
        create(:product, name: "Taken Product")

        visit new_admin_product_path
        fill_in "Product name *Required*", with: "Taken Product"
        fill_in "User email", with: "user@va.gov"

        click_button "Create Product"

        expect(page).to have_content("Product name already exists")
        expect(current_path).to eq(new_admin_product_path)

        expect(Product.where(name: "Taken Product").count).to eq(1)
      end
    end
  end

  describe "Updating a product" do
    let!(:product) { create(:product, name: "Old Product", user: create(:user, email: "olduser@va.gov")) }

    context "with valid attributes" do
      scenario "updates a product successfully" do
        visit edit_admin_product_path(product)

        fill_in "Product name *Required*", with: "Updated Product"
        fill_in "User email", with: "newuser@va.gov"

        click_button "Update Product"

        expect(page).to have_content("Product was successfully updated")
        expect(page).to have_content("Updated Product")
        expect(page).to have_content("newuser@va.gov")
      end

      scenario "allows the user_email to be blank and sets the product's user to nil" do
        visit edit_admin_product_path(product)

        fill_in "Product name *Required*", with: "Updated Product"
        fill_in "User email", with: ""

        click_button "Update Product"

        expect(page).to have_content("Product was successfully updated")
        expect(page).to have_content("Updated Product")
        expect(product.reload.user).to be_nil
      end
    end

    context "with invalid attributes" do
      scenario "tries to update a product with an invalid email" do
        visit edit_admin_product_path(product)

        fill_in "Product name *Required*", with: "Updated Product"
        fill_in "User email", with: "invalidemail.com"

        click_button "Update Product"

        expect(page).to have_content("Email must be a valid @va.gov address")
        expect(current_path).to eq(edit_admin_product_path(product))

        expect(product.reload.user.email).to eq("olduser@va.gov")
      end

      scenario "tries to update a product with a taken name" do
        create(:product, name: "Taken Product")

        visit edit_admin_product_path(product)
        fill_in "Product name *Required*", with: "Taken Product"
        fill_in "User email", with: "newuser@va.gov"

        click_button "Update Product"

        expect(page).to have_content("Product name already exists")
        expect(current_path).to eq(edit_admin_product_path(product))

        expect(product.reload.name).to eq("Old Product")
      end
    end
  end
end
