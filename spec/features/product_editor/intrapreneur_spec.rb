require 'rails_helper'

describe 'Product editor - intrapreneur details', type: :feature do
  let!(:user) { create(:user) }
  let!(:product_owner) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let!(:product) { create(
                    :product,
                    :with_va_employees,
                    origin_story: "This is the origin story of the product.",
                    user: product_owner
  )}

  before do
    login_as(current_user, scope: :user, run_callbacks: false)
  end

  describe 'when logged in as a regular user' do
    let(:current_user) { user }

    context 'with no permissions' do
      it 'redirects to the root path with a warning' do
        visit product_intrapreneur_path(product)
        expect(page).to have_current_path('/')
        expect(page).to have_content('You are not authorized to view this content.')
      end
    end
  end

  describe 'when logged in as the product owner' do
    let(:current_user) { product_owner }

    context 'accessing the intrapreneur details page' do
      it 'allows access and displays the product details' do
        visit product_intrapreneur_path(product)

        expect(page).to have_content(product.origin_story)
        product.va_employees.each do |va_employee|
          expect(page).to have_field("product_va_employees_attributes_#{va_employee.id - 1}_name", with: va_employee.name)
          expect(page).to have_field("product_va_employees_attributes_#{va_employee.id - 1}_role", with: va_employee.role)
        end
      end

      it 'allows adding a new va_employee' do
        visit product_intrapreneur_path(product)

        click_link 'Add another'

        within '#innovators-container' do
          all('.va-employee-name-input').last.set('New Innovator')
          all('.va-employee-role').last.set('New Role')
        end

        click_link "Save and Continue"
        new_va_employee = product.va_employees.last
        expect(page).to have_content('Product was successfully updated.')
        expect(page).to have_current_path(product_multimedia_path(product))
        visit product_intrapreneur_path(product)
        expect(page).to have_field("product_va_employees_attributes_#{new_va_employee.id - 1}_name", with: new_va_employee.name)
        expect(page).to have_field("product_va_employees_attributes_#{new_va_employee.id - 1}_role", with: new_va_employee.role)
      end

      it 'allows updating a va_employee' do
        visit product_intrapreneur_path(product)

        fill_in "product_va_employees_attributes_0_name", with: 'Updated Name'
        fill_in "product_va_employees_attributes_0_role", with: 'Updated Role'
        click_link "Save and Continue"
        va_employee = product.va_employees.first
        expect(page).to have_content('Product was successfully updated.')
        expect(page).to have_current_path(product_multimedia_path(product))
        visit product_intrapreneur_path(product)
        expect(page).to have_field("product_va_employees_attributes_#{va_employee.id - 1}_name", with: 'Updated Name')
        expect(page).to have_field("product_va_employees_attributes_#{va_employee.id - 1}_role", with: 'Updated Role')
      end

      it 'allows deleting a va_employee' do
        visit product_intrapreneur_path(product)

        within '#innovators-container' do
          all('a', text: 'Delete entry').last.click
        end
        click_link "Save and Continue"

        expect(page).to have_content('Product was successfully updated.')
        expect(product.va_employees.count).to eq(2)
      end

      it 'allows updating the origin story' do
        visit product_intrapreneur_path(product)

        fill_in 'product_origin_story', with: 'Updated text'
        click_link "Save and Continue"

        expect(page).to have_content('Product was successfully updated.')
        expect(page).to have_current_path(product_multimedia_path(product))
        visit product_intrapreneur_path(product)
        expect(page).to have_field("product_origin_story", with: 'Updated text')
      end
    end
  end

  describe 'when logged in as an admin' do
    let(:current_user) { admin }

    it 'allows access and displays the product details' do
      visit product_intrapreneur_path(product)

      expect(page).to have_content(product.origin_story)

      product.va_employees.each do |va_employee|
        expect(page).to have_field("product_va_employees_attributes_#{va_employee.id - 1}_name", with: va_employee.name)
        expect(page).to have_field("product_va_employees_attributes_#{va_employee.id - 1}_role", with: va_employee.role)
      end
    end
  end

  describe 'when not logged in' do
    let(:current_user) { nil }

    context 'without login' do
      it 'redirects to the login page' do
        visit product_intrapreneur_path(product)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
