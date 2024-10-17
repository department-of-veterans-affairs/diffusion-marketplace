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
      click_link 'Save and Continue'

      expect(page).to have_content('Product was successfully updated.')
      expect(product.reload.name).to eq('Updated Product Name')
    end

    it 'shows validation errors for missing required fields' do
      visit product_description_path(product)

      fill_in 'product_name', with: ''
      click_link 'Save and Continue'
      expect(page).to have_current_path(product_description_path(product))
      expect(page).to have_selector("input:invalid")
    end

    it 'shows model validation errors' do
      new_product = create(:product, name: 'more different name')
      visit product_description_path(new_product)

      fill_in 'product_name', with: product.name
      click_link 'Save and Continue'
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

      click_link 'Save and Continue'

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
      click_link 'Save and Continue'

      expect(product.categories).to include(cat2)
      expect(product.categories).to_not include(cat1)
    end

    context 'when managing the thumbnail image' do
      it 'uploads and displays the thumbnail image' do
        visit product_description_path(product)
        attach_file 'product_main_display_image', Rails.root.join('spec/assets/acceptable_img.jpg')
        fill_in 'product_main_display_image_caption', with: 'Caption text'
        fill_in 'product_main_display_image_alt_text', with: 'Alt Text'
        click_link 'Save and Continue'

        expect(page).to have_content('Product was successfully updated.')
        visit product_description_path(product)
        expect(page).to have_css("img[src*='acceptable_img.jpg']")
      end

      it 'updates the caption and alt text for the thumbnail image' do
        product.update!(main_display_image_alt_text: "Test", main_display_image_caption: "Other Test")
        visit product_description_path(product)

        attach_file 'product_main_display_image', Rails.root.join('spec/assets/acceptable_img.jpg')

        fill_in 'product_main_display_image_caption', with: 'Updated Caption'
        fill_in 'product_main_display_image_alt_text', with: 'Updated Alt Text'
        click_link 'Save and Continue'

        expect(page).to have_content('Product was successfully updated.')
        product.reload
        expect(product.main_display_image_caption).to eq('Updated Caption')
        expect(product.main_display_image_alt_text).to eq('Updated Alt Text')
      end

      it 'removes the thumbnail image' do
        product.update!(main_display_image_alt_text: "Test", main_display_image_caption: "Other Test")
        product.update(main_display_image: fixture_file_upload('spec/assets/acceptable_img.jpg', 'image/jpg'))

        visit product_description_path(product)
        find('label', text: 'Remove image').click
        click_link 'Save and Continue'
        expect(page).to have_content('Product was successfully updated.')

        product.reload
        expect(product.main_display_image.exists?).to be false
      end
    end

    context 'when managing practice partners' do
      let!(:pp_a) { create(:practice_partner, name: "Diffusion of Excellence") }
      let!(:pp_b) { create(:practice_partner, name: "Health Services Research & Development")}

      it 'allows a practice partner to be added' do
        visit product_description_path(product)
        find('#link_to_add_link_practice_partner_practices').click
        within(all('.dm-practice-editor-practice-partner-li').last) do
          find('.usa-combo-box__input').click
          find('.usa-combo-box__input').set("Diffusion of Excellence")
          all('.usa-combo-box__list-option').first.click
        end

        click_link 'Save and Continue'
        expect(page).to have_content('Product was successfully updated.')
        visit product_description_path(product)
        expect(find(:css, '#product_practice_partner_practices_attributes_0_practice_partner_id').value).to eq(pp_a.name)
      end

      it 'allows a practice partner to be changed' do
        visit product_description_path(product)
        within(all('.dm-practice-editor-practice-partner-li').last) do
          find('.usa-combo-box__input').click
          find('.usa-combo-box__input').set("Health Services Research & Development")
          all('.usa-combo-box__list-option').first.click
        end

        click_link 'Save and Continue'
        expect(page).to have_content('Product was successfully updated.')
        visit product_description_path(product)
        expect(find(:css, '#product_practice_partner_practices_attributes_0_practice_partner_id').value).to eq(pp_b.name)
      end

      it "allows a practice partner to be removed" do
        product.practice_partner_practices.create(practice_partner: pp_a)
        product.practice_partner_practices.create(practice_partner: pp_b)

        visit product_description_path(product)
        within(all('.dm-practice-editor-practice-partner-li')[0]) do
          click_link('Delete entry')
        end

        click_link 'Save and Continue'
        expect(page).to have_content('Product was successfully updated.')
        visit product_description_path(product)
        expect(find(:css, '#product_practice_partner_practices_attributes_0_practice_partner_id').value).to eq("Health Services Research & Development")
      end

      it "allows all practice partners to be removed" do
        product.practice_partner_practices.create(practice_partner: pp_a)

        visit product_description_path(product)
        within(all('.dm-practice-editor-practice-partner-li').last) do
          find('button[aria-label="Clear the select contents"]').click
        end

        click_link 'Save and Continue'
        expect(page).to have_content('Product was successfully updated.')
        expect(product.practice_partners).to be_empty
      end
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
