require 'rails_helper'

describe 'Page Management', type: :feature, js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:editor) { create(:user) }
  let!(:page_group) { create(:page_group, name: 'programming') }
  let!(:pb_page_a) { create(:page, title: 'Test', description: 'This is a test page', slug: 'test-page', page_group: page_group) }
  let!(:pb_page_b) { create(:page, page_group: page_group) }
  let!(:image_file) { "#{Rails.root}/spec/assets/charmander.png" }
  let!(:practice) { create(:practice, name: 'Best Innovation Ever') }


  before do
    editor.add_role(:page_group_editor, page_group)
    login_as(editor, scope: :user, run_callbacks: false)
  end

  describe 'index' do
    it 'Should show only and all pages belonging to page_groups for which user is editor' do
      page_group2 = create(:page_group)
      pb_page_c = create(:page, page_group: page_group2)
      visit_pages_tab_of_editor_panel

      expect(page).to have_content(pb_page_a.slug)
      expect(page).to have_content(pb_page_b.slug)
      expect(page).to_not have_content(pb_page_c.slug)

      editor.add_role(:page_group_editor, page_group2)
      visit_pages_tab_of_editor_panel

      expect(page).to have_content(pb_page_a.slug)
      expect(page).to have_content(pb_page_b.slug)
      expect(page).to have_content(pb_page_c.slug)
    end
  end

  describe 'Validations' do
    it 'Should only allow unique page URLs' do
      visit_pages_tab_of_editor_panel

      click_link 'New Page'

      fill_in_necessary_page_fields('test-page')
      save_page

      expect(page).to have_content('Slug has already been taken')
    end

    it 'Should not allow the user to add a description that is longer than 140 characters' do
      visit_pages_tab_of_editor_panel
      click_link 'New Page'

      fill_in 'URL', with: 'test-page-1'
      fill_in 'Description', with: 'In vehicula leo vitae mattis eleifend. Praesent volutpat ipsum et tincidunt laoreet. Nullam mattis rutrum posuere. Nunc leo neque, molestie nec'
      select 'programming', from: 'page_page_group_id'
      save_page

      expect(page).to have_content('Description is too long (maximum is 140 characters')
      expect(Page.last.slug).to_not eq('test-page-1')
      expect(Page.last.slug).to eq(pb_page_b.slug)
    end

    it 'should not allow the user to upload an image for the Page without corresponding alt text' do
      visit edit_editor_page_path(pb_page_a)

      within(:css, '#page_image_input') do
        find('input[type="file"]').attach_file(image_file)
      end
      save_page

      expect(page).to have_content("Image alt text can't be blank if Page image is present")
      expect(pb_page_a.image.present?).to eq(false)
    end
  end

  describe 'creating the page' do
    it 'Should make the page' do
      visit_pages_tab_of_editor_panel

      expect(page).to have_current_path(editor_pages_path)
      click_link 'New Page'

      expect(page).to have_current_path(new_editor_page_path)

      fill_in_necessary_page_fields('hello-world')
      save_page

      expect(page).to have_current_path(editor_page_path(Page.last.id))

      expect(page).to have_content('Hello world!')
      expect(page).to have_content('This is the first page built.')
      expect(page).to have_content('/programming/hello-world')
    end

    it 'should allow the user to upload and delete both an image and supplemental alt text for a Page' do
      # Upload an image/alt text
      visit new_editor_page_path
      fill_in_necessary_page_fields('hello-world')
      within(:css, '#page_image_input') do
        find('input[type="file"]').attach_file(image_file)
      end
      fill_in('Image alternative text (required if image present)', with: 'Descriptive alt text')
      save_page

      expect(page).to have_content('Page was successfully created.')
      expect(page).to have_content('Image'.upcase)
      expect(page).to have_css("img[src*='#{Page.last.image_s3_presigned_url}']")
      expect(page).to have_content('Image Alt Text'.upcase)
      expect(page).to have_content(Page.last.image_alt_text)
      # Delete the image/alt text
      visit edit_editor_page_path(Page.last)
      find('#page_delete_image_and_alt_text').click
      save_page

      expect(page).to have_content('Page was successfully updated.')
      expect(page).to_not have_content('Image'.upcase)
      expect(Page.last.image.present?).to eq(false)
      expect(page).to_not have_css("img[src*='#{Page.last.image_s3_presigned_url}']")
      expect(page).to_not have_content('Image Alt Text'.upcase)
      expect(Page.last.image_alt_text.present?).to eq(false)
    end

    it 'allows editor to update short_name and community page status' do
      visit edit_editor_page_path(pb_page_a)
      fill_in 'Page Nickname', with: 'Quick Ref'
      find('input[name="page[is_community_page]"]').set(true)
      all('input[type="submit"]').last.click
      expect(page).to have_content('Page was successfully updated.')
      updated_page = Page.find(pb_page_a.id)
      expect(updated_page.short_name).to eq('Quick Ref')
      expect(updated_page.is_community_page).to be true
    end
  end

  describe 'Page groups' do
    it 'Should create a new page group landing page if the user types home into the url field and chooses a page group' do
      visit_pages_tab_of_editor_panel
      click_link 'New Page'

      fill_in 'URL', with: 'home'
      fill_in 'Title', with: 'Awesome Landing Page'
      fill_in 'Description', with: 'This is an awesome page group landing page.'
      select 'programming', from: 'page_page_group_id'
      save_page

      expect(page).to have_current_path(editor_page_path(Page.last.id))
      expect(page).to have_content('Awesome Landing Page')
      expect(page).to have_content('This is an awesome page group landing page')
      expect(page).to have_content('home')
      expect(page).to have_content('/programming')
    end
  end

  describe 'Page components' do
    context 'PageMapComponent' do
      it 'should allow the user to create a PageMapComponent' do
        # Create one
        visit edit_editor_page_path(pb_page_a)
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
        visit edit_editor_page_path(pb_page_a)
        # Add a 'PageAccordionComponent' and select the border option
        click_link('Add New Page component')
        select('Accordion', from: 'page_page_components_attributes_0_component_type')
        fill_in('page_page_components_attributes_0_component_attributes_title', with: 'Some Accordion Title')
        find('#page_page_components_attributes_accordion_0_component_attributes_text').click
        expect(page).to have_selector('.tox-edit-area__iframe')
        within_frame(all('.tox-edit-area__iframe')[0]) do
          find('body').set('Foo bar')
        end
        find('#page_page_components_attributes_0_component_attributes_has_border').click
        save_page

        expect(page).to have_content('Page was successfully updated.')
        expect(page).to have_text('Has border: true')
      end
    end

    context 'Validations' do
      it 'should indicate validation errors for page components' do
        visit edit_editor_page_path(pb_page_a)
        # Add a 'PageAccordionComponent' and select the border option
        click_link('Add New Page component')
        select('Block Quote', from: 'page_page_components_attributes_0_component_type')
        save_page
        expect(page).to have_content("Block Quote errors: [Text can't be blank, Citation can't be blank]")
      end
    end
  end

  def visit_pages_tab_of_editor_panel
    visit '/editor'
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
    select('programming', from: 'Page Group / Community*')
  end
end
