require 'rails_helper'

describe 'Product editor - multimedia details', type: :feature do
  let!(:user) { create(:user) }
  let!(:product_owner) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let!(:product) { create(:product, :with_multimedia, user: product_owner) }

  before do
    login_as(current_user, scope: :user, run_callbacks: false)
  end

  shared_examples 'multimedia page access' do
    context 'accessing the multimedia details page' do
      it 'allows access and displays the product multimedia details' do
        visit product_multimedia_path(product)

        product.practice_multimedia.each do |media|
          case media.resource_type
          when 'image'
            expect(page).to have_selector("img[src*='#{media.attachment_file_name}']")
          when 'video'
            expect(page).to have_field("practice[practice_multimedia_attributes][0_video][link_url]", with: media.link_url)
          when 'file'
            expect(page).to have_content(media.attachment_file_name)
          when 'link'
            expect(page).to have_field("practice[practice_multimedia_attributes][0_link][link_url]", with: media.link_url)
          end
        end
      end
    end
  end

  describe 'when logged in as a regular user' do
    let(:current_user) { user }

    context 'with no permissions' do
      it 'redirects to the root path with a warning' do
        visit product_multimedia_path(product)
        expect(page).to have_current_path('/')
        expect(page).to have_content('You are not authorized to view this content.')
      end
    end
  end

  describe 'when logged in as the product owner' do
    let(:current_user) { product_owner }

    context 'accessing the multimedia details page' do
      include_examples 'multimedia page access'

      it 'allows adding a new image' do
        visit product_multimedia_path(product)

        find('label', text: 'Image').click
        attach_file 'practice[practice_multimedia_attributes][RANDOM_NUMBER_OR_SOMETHING_image][attachment]', Rails.root.join('spec/assets/acceptable_img.jpg')
        fill_in 'practice[practice_multimedia_attributes][RANDOM_NUMBER_OR_SOMETHING_image][name]', with: 'Test Image'
        fill_in 'practice[practice_multimedia_attributes][RANDOM_NUMBER_OR_SOMETHING_image][image_alt_text]', with: 'Alt text for test image'
        click_button 'Add image'
        click_button 'Submit'
        expect(page).to have_content('Product was successfully updated.')
        visit product_multimedia_path(product)
        expect(page).to have_field("practice[practice_multimedia_attributes][1_image][name]", with: 'Test Image')
        expect(page).to have_selector("img[src*='acceptable_img.jpg']")
      end

      it 'allows adding a new video' do
        visit product_multimedia_path(product)

        find('label', text: 'Video').click
        fill_in 'practice[practice_multimedia_attributes][RANDOM_NUMBER_OR_SOMETHING_video][link_url]', with: 'https://www.youtube.com/watch?v=example'
        fill_in 'practice[practice_multimedia_attributes][RANDOM_NUMBER_OR_SOMETHING_video][name]', with: 'Test Video'
        click_button 'Add video'
        click_button 'Submit'
        expect(page).to have_content('Product was successfully updated.')
        visit product_multimedia_path(product)
        expect(page).to have_field("practice[practice_multimedia_attributes][1_video][name]", with: 'Test Video')
        expect(page).to have_field("practice[practice_multimedia_attributes][1_video][link_url]", with: 'https://www.youtube.com/watch?v=example')
      end

      it 'allows updating a multimedia entry' do
        visit product_multimedia_path(product)

        fill_in "practice[practice_multimedia_attributes][0_image][name]", with: 'Updated Media Name'
        click_button 'Submit'

        expect(page).to have_content('Product was successfully updated.')
        visit product_multimedia_path(product)
        expect(page).to have_field("practice[practice_multimedia_attributes][0_image][name]", with: 'Updated Media Name')
      end

      it 'allows deleting a multimedia entry' do
        visit product_multimedia_path(product)

        within '#display_multimedia_image' do
          all('button', text: 'Delete entry').last.click
        end
        click_button 'Submit'

        expect(page).to have_content('Product was successfully updated.')
        expect(product.practice_multimedia.count).to eq(3)
      end
    end
  end

  describe 'when logged in as an admin' do
    let(:current_user) { admin }

    include_examples 'multimedia page access'
  end

  describe 'when not logged in' do
    let(:current_user) { nil }

    context 'without login' do
      it 'redirects to the login page' do
        visit product_multimedia_path(product)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
