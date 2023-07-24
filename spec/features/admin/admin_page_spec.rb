require 'rails_helper'

describe 'Page Builder', type: :feature do
  before do
    @admin = User.create!(email: 'sandy.cheeks@bikinibottom.net', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)

    @page_group = PageGroup.create(name: 'programming', description: 'Pages about programming go in this group.')
    @page = Page.create!(title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: @page_group)
    @image_file = "#{Rails.root}/spec/assets/charmander.png"
    @admin = User.create!(email: 'dokugamine.riruka@va.gov', password: 'Password123',
                          password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(:admin)
    @practice = Practice.create!(name: 'Best Innovation Ever', user: @admin, initiating_facility_type: 'facility', initiating_facility: '678GC', tagline: 'Test tagline')


    login_as(@admin, scope: :user, run_callbacks: false)
  end

  describe 'Validations' do
    it 'Should only allow unique page URLs' do
      visit_pages_tab_of_admin_panel
      click_link 'New Page'

      fill_in_necessary_page_fields('test-page')
      save_page

      expect(page).to have_content('Slug has already been taken')
    end

    it 'Should not allow the user to add a description that is longer than 140 characters' do
      visit_pages_tab_of_admin_panel
      click_link 'New Page'

      fill_in 'URL', with: 'test-page-1'
      fill_in 'Description', with: 'In vehicula leo vitae mattis eleifend. Praesent volutpat ipsum et tincidunt laoreet. Nullam mattis rutrum posuere. Nunc leo neque, molestie nec'
      select 'programming', from: 'page_page_group_id'
      save_page

      expect(page).to have_content('Validation failed. Page description cannot be longer than 140 characters.')
      expect(Page.last.slug).to_not eq('test-page-1')
      expect(Page.last.slug).to eq('test-page')
    end

    it 'should not allow the user to upload an image for the Page without corresponding alt text' do
      visit edit_admin_page_path(@page)

      within(:css, '#page_image_input') do
        find('input[type="file"]').attach_file(@image_file)
      end
      save_page

      expect(page).to have_content('Validation failed. Page cannot have an optional image without alternative text.')
      expect(@page.image.present?).to eq(false)
    end
  end

  describe 'creating the page' do
    it 'Should make the page' do
      visit_pages_tab_of_admin_panel

      expect(page).to have_current_path(admin_pages_path)
      click_link 'New Page'

      expect(page).to have_current_path(new_admin_page_path)

      fill_in_necessary_page_fields('hello-world')
      save_page

      expect(page).to have_current_path(admin_page_path(Page.last.id))

      expect(page).to have_content('Hello world!')
      expect(page).to have_content('This is the first page built.')
      expect(page).to have_content('/programming/hello-world')

      # TODO: Figure out how to prevent database cleaning after opening new tab
      # click_link '/programming/hello-world'
    end

    it 'should allow the user to upload and delete both an image and supplemental alt text for a Page' do
      # Upload an image/alt text
      visit new_admin_page_path
      fill_in_necessary_page_fields('hello-world')
      within(:css, '#page_image_input') do
        find('input[type="file"]').attach_file(@image_file)
      end
      fill_in('Image alternative text (required if image present)', with: 'Descriptive alt text')
      save_page

      expect(page).to have_content('Page was successfully created.')
      expect(page).to have_content('Image'.upcase)
      expect(page).to have_css("img[src*='#{Page.last.image_s3_presigned_url}']")
      expect(page).to have_content('Image Alt Text'.upcase)
      expect(page).to have_content(Page.last.image_alt_text)
      # Delete the image/alt text
      visit edit_admin_page_path(Page.last)
      find('#page_delete_image_and_alt_text').click
      save_page

      expect(page).to have_content('Page was successfully updated.')
      expect(page).to_not have_content('Image'.upcase)
      expect(Page.last.image.present?).to eq(false)
      expect(page).to_not have_css("img[src*='#{Page.last.image_s3_presigned_url}']")
      expect(page).to_not have_content('Image Alt Text'.upcase)
      expect(Page.last.image_alt_text.present?).to eq(false)
    end
  end

  describe 'Page groups' do
    it 'Should create a new page group landing page if the user types home into the url field and chooses a page group' do
      visit_pages_tab_of_admin_panel
      click_link 'New Page'

      fill_in 'URL', with: 'home'
      fill_in 'Title', with: 'Awesome Landing Page'
      fill_in 'Description', with: 'This is an awesome page group landing page.'
      select 'programming', from: 'page_page_group_id'
      save_page

      expect(page).to have_current_path(admin_page_path(Page.last.id))
      expect(page).to have_content('Awesome Landing Page')
      expect(page).to have_content('This is an awesome page group landing page')
      expect(page).to have_content('home')
      expect(page).to have_content('/programming')

      # TODO: Figure out how to prevent database cleaning after opening new tab
      # click_link '/programming'
    end
  end

  describe 'Page components' do
    context 'PageMapComponent' do
      it 'should allow the user to create a PageMapComponent' do
        # Create one
        visit edit_admin_page_path(@page)
        click_link('Add New Page component')
        select('Google Map', from: 'page_page_components_attributes_0_component_type')
        fill_in("page_page_components_attributes_0_component_attributes_title", with: 'Diffusion Map')
        fill_in("page_page_components_attributes_0_component_attributes_map_info_window_text", with: 'Diffusion Map Info Window Text')
        select('Best Innovation Ever', from: 'page_page_components_attributes_0_component_attributes_map')
        save_page
        expect(page).to have_content('Page was successfully updated.')
        expect(page).to have_content('Google Map')
        expect(page).to have_content('Diffusion Map')
        expect(page).to have_content('Diffusion Map Info Window Text')
      end
    end

    context 'PageAccordionComponent' do
      it 'should allow the user to toggle border styling' do
        visit edit_admin_page_path(@page)
        # Add a 'PageAccordionComponent' and select the border option
        click_link('Add New Page component')
        select('Accordion', from: 'page_page_components_attributes_0_component_type')
        fill_in('page_page_components_attributes_0_component_attributes_title', with: 'Some Accordion Title')
        within_frame(all('.tox-edit-area__iframe')[0]) do
          find('body').set('Foo bar')
        end
        find('#page_page_components_attributes_0_component_attributes_has_border').click
        save_page

        expect(page).to have_content('Page was successfully updated.')
        expect(page).to have_text('Has border: true')
      end
    end
  end

  def visit_pages_tab_of_admin_panel
    visit '/admin'
    click_link 'Pages'
  end

  def save_page
    find_all('input[type="submit"]').first.click
  end

  def fill_in_compound_body_component_fields(
    component_index,
    wysiwyg_editor_index,
    wysiwyg_editor_content,
    url_link_text
  )
    fill_in("page_page_components_attributes_#{component_index}_component_attributes_title_header", with: 'Cool Title Header')
    fill_in("page_page_components_attributes_#{component_index}_component_attributes_title", with: 'Cool Title')
    within_frame(all('.tox-edit-area__iframe')[wysiwyg_editor_index]) do
      find('body').set(wysiwyg_editor_content)
    end
    fill_in("page_page_components_attributes_#{component_index}_component_attributes_url", with: '/')
    fill_in("page_page_components_attributes_#{component_index}_component_attributes_url_link_text", with: url_link_text)
    select(1, from: "page_page_components_attributes_#{component_index}_component_attributes_padding_bottom")
    select(4, from: "page_page_components_attributes_#{component_index}_component_attributes_padding_top")
  end

  def fill_in_necessary_page_fields(url)
    fill_in 'URL', with: url
    fill_in 'Title', with: 'Hello world!'
    fill_in 'Description', with: 'This is the first page built.'
    select('programming', from: 'Group*')
  end
end