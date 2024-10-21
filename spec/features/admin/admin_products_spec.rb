require 'rails_helper'

RSpec.feature "Admin::Products", type: :feature do
  let(:admin_user) { create(:user, :admin) }
  let(:product_user) { create(:user) }

  before do
    login_as(admin_user, scope: :user)
  end

  describe "Creating a product" do
    context "with valid attributes" do
      scenario "creates a product successfully and adds user as editor" do
        visit new_admin_product_path
        user_email = product_user.email
        fill_in "Product name *Required*", with: "Test Product"
        fill_in "User email", with: "#{user_email}"

        click_button "Create Product"

        expect(page).to have_content("Product was successfully created")
        expect(page).to have_content("Test Product")
        expect(page).to have_content(user_email)
        expect(PracticeEditor.last.user).to eq(product_user)
        expect(PracticeEditor.last.innovable.name).to eq("Test Product")
      end

      scenario "creates a product and adds another" do
        visit new_admin_product_path

        fill_in "Product name *Required*", with: "First Product"
        fill_in "User email", with: product_user.email
        check "create_another"

        click_button "Create Product"

        expect(page).to have_content("Product was successfully created. You can create another one.")
        expect(current_path).to eq(new_admin_product_path)
        expect(page).not_to have_field("Product name *Required*", with: "First Product")
      end
    end

    context "with invalid attributes" do
      scenario "tries to create a product with a non-VA email" do
        visit new_admin_product_path

        fill_in "Product name *Required*", with: "Invalid Email Product"
        fill_in "User email", with: "invalidemail.com"

        click_button "Create Product"

        expect(page).to have_content("Email must be a valid @va.gov address")
        expect(current_path).to eq(new_admin_product_path)

        expect(Product.find_by(name: "Invalid Email Product")).to be_nil
      end

      scenario "tries to create a product with an invalid email" do
        visit new_admin_product_path

        fill_in "Product name *Required*", with: "Invalid Email Product"
        fill_in "User email", with: "invalidemail@va.gov"

        click_button "Create Product"

        expect(page).to have_content("Email does not match any registered users")
        expect(current_path).to eq(new_admin_product_path)

        expect(Product.find_by(name: "Invalid Email Product")).to be_nil
      end

      scenario "tries to create a product with a taken name" do
        create(:product, name: "Taken Product")

        visit new_admin_product_path
        fill_in "Product name *Required*", with: "Taken Product"
        fill_in "User email", with: product_user.email

        click_button "Create Product"

        expect(page).to have_content("Product name already exists")
        expect(current_path).to eq(new_admin_product_path)

        expect(Product.where(name: "Taken Product").count).to eq(1)
      end
    end
  end

  describe "Editing a product" do
    let!(:product) { create(:product, name: "Old Product", user: create(:user, email: "olduser@va.gov")) }

    context "with valid attributes" do
      scenario "updates a product successfully" do
        visit edit_admin_product_path(product)

        fill_in "Product name *Required*", with: "Updated Product"
        fill_in "User email", with: product_user.email

        click_button "Update Product"

        expect(page).to have_content("Product was successfully updated")
        expect(page).to have_content("Updated Product")
        expect(page).to have_content(product_user.email)
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
        fill_in "User email", with: ""

        click_button "Update Product"

        expect(page).to have_content("Product name already exists")
        expect(current_path).to eq(edit_admin_product_path(product))

        expect(product.reload.name).to eq("Old Product")
      end
    end
  end

  describe "Retiring and publishing products" do
    let!(:product) { create(:product, name: "Test Product", user: create(:user, email: "olduser@va.gov")) }

    scenario "publish a product" do
      visit admin_products_path
      within find('tr', text: "Test Product") do
        click_link "Publish"
      end

      expect(page).to have_content("\"Test Product\" was published")
      expect(product.reload.published).to be true
    end

    scenario "unpublish a product" do
      product.update(published: true)

      visit admin_products_path

      click_link "Unpublish", match: :first

      expect(page).to have_content("\"Test Product\" was unpublished")
      expect(product.reload.published).to be false
    end

    scenario "retire a product" do
      visit admin_products_path
      click_link "Retire", match: :first

      expect(page).to have_content("\"Test Product\" was retired")
      expect(product.reload.retired).to be true
    end

    scenario "activate a retired product" do
      product.update(retired: true)

      visit admin_products_path

      click_link "Activate", match: :first

      expect(page).to have_content("\"Test Product\" was activated")
      expect(product.reload.retired).to be false
    end
  end
end
