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

      fill_in 'URL', with: 'test-page'
      fill_in 'Title', with: 'Test Page'
      fill_in 'Description', with: 'This page will not get created.'
      select 'programming', from: 'page_page_group_id'
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

    it 'should not allow the user to save a PageComponentImage without an image or alt text' do
      def expect_page_component_image_to_not_be_saved
        expect(page).to have_current_path(admin_page_path(@page))
        expect(page).to have_content("One or more 'Compound Body' components had missing required fields for its image(s). The page was saved, but those image(s) were not.")
        expect(PageComponentImage.count).to eq(0)
      end
      # Try to save a PageComponentImage without an image
      visit edit_admin_page_path(@page)
      click_link('Add New Page component')
      select('Text and Images', from: 'page_page_components_attributes_0_component_type')
      fill_in_optional_page_component_image_fields(0, '/visns', 1, 'Amazing caption')

      fill_in('Alternative text *required*', with: 'Some alt text')
      save_page

      expect_page_component_image_to_not_be_saved
      # Now to to save one without alt text
      visit edit_admin_page_path(@page)
      click_link('Add New Page component')
      select('Text and Images', from: 'page_page_components_attributes_0_component_type')
      fill_in_optional_page_component_image_fields(0, '/search', 1, 'Cool caption')

      all('input[type="file"]').first.attach_file(@image_file)
      save_page

      expect_page_component_image_to_not_be_saved
    end
  end

  it 'Should make the page' do
    visit_pages_tab_of_admin_panel

    expect(page).to have_current_path(admin_pages_path)
    click_link 'New Page'

    expect(page).to have_current_path(new_admin_page_path)

    fill_in 'URL', with: 'hello-world'
    fill_in 'Title', with: 'Hello world!'
    fill_in 'Description', with: 'This is the first page built.'
    select 'programming', from: 'page[page_group_id]'
    save_page

    expect(page).to have_current_path(admin_page_path(Page.last.id))

    expect(page).to have_content('Hello world!')
    expect(page).to have_content('This is the first page built.')
    expect(page).to have_content('/programming/hello-world')

    # TODO: Figure out how to prevent database cleaning after opening new tab
    # click_link '/programming/hello-world'
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
    context 'PageCompoundBodyComponent' do
      it 'should allow the user to create and destroy many PageCompoundBodyComponents' do
        # Create one
        visit edit_admin_page_path(@page)
        click_link('Add New Page component')
        select('Text and Images', from: 'page_page_components_attributes_0_component_type')
        fill_in_compound_body_component_fields(
          0,
          0,
          'Some cool text',
          'Hello World'
        )
        # Create another
        click_link('Add New Page component')
        select('Text and Images', from: 'page_page_components_attributes_1_component_type')
        fill_in_compound_body_component_fields(
          1,
          1,
          'Amazing description',
          'Hello Universe'
        )
        save_page

        expect(page).to have_content('Page was successfully updated.')
        expect(page).to have_content('Text and Images')
        expect(page).to have_content('Amazing description')
        expect(page).to have_content('Hello Universe')
        # Destroy one
        expect(@page.page_components.count).to eq(2)
        visit edit_admin_page_path(@page)
        find('#page_page_components_attributes_0__destroy').click
        save_page
        expect(page).to have_content('Page was successfully updated.')
        expect(@page.page_components.count).to eq(1)
        visit edit_admin_page_path(@page)
        expect(page).to have_selector('li', id: 'PageCompoundBodyComponent_poly_0')
        expect(page).to have_field('URL link text', with: 'Hello Universe')
        within_frame(all('.tox-edit-area__iframe')[0]) do
          expect(find('body')).to have_text('Amazing description')
        end
        expect(page).to_not have_selector('li', id: 'PageCompoundBodyComponent_poly_1')
      end

      context 'PageComponentImages' do
        it 'should allow the user to create an destroy many PageComponentImages for any PageCompoundBodyComponent' do
          # Create a page
          visit_pages_tab_of_admin_panel
          click_link 'New Page'
          fill_in('URL', with: 'home')
          fill_in('Title', with: 'Test')
          fill_in('Description', with: 'Test')
          select('programming', from: 'Group*')
          # Create the CompoundBodyComponent
          click_link('Add New Page component')
          select('Text and Images', from: 'page_page_components_attributes_0_component_type')
          fill_in_compound_body_component_fields(
            0,
            0,
            'Test',
            'Some awesome link!'
          )
          # Create the image
          fill_in_optional_page_component_image_fields(
            0,
            '/visns',
            1,
            'Awesome caption'
          )
          fill_in_required_page_component_image_fields(0, 'test alt text')
          save_page

          expect(page).to have_content('Page was successfully created.')
          expect(page).to have_content('URL: /visns')
          expect(page).to have_content('Awesome caption')
          expect(page).to have_content('Alt text: test alt text')
          expect(PageComponentImage.count).to eq(1)
          visit edit_admin_page_path(Page.last)
          expect(page).to have_field('URL', with: '/visns')
          expect(page).to have_field('Alternative text', with: 'test alt text')
          within_frame(all('.tox-edit-area__iframe')[1]) do
            expect(find('body')).to have_text('Awesome caption')
          end
          # Add another image and delete the first one
          fill_in_optional_page_component_image_fields(
            1,
            '/search',
            2,
            'Test caption'
          )
          fill_in_required_page_component_image_fields(1, 'random alt text')
          all('.dm-page-builder-trash').first.click
          save_page

          expect(page).to have_content('Page was successfully updated.')
          expect(PageComponentImage.count).to eq(1)
          visit edit_admin_page_path(Page.last)
          expect(page).to have_field('URL', with: '/search')
          expect(page).to have_field('Alternative text', with: 'random alt text')
          within_frame(all('.tox-edit-area__iframe')[1]) do
            expect(find('body')).to have_text('Test caption')
          end
          expect(page).to_not have_field('URL', with: '/visns')
          expect(page).to_not have_field('Alternative text', with: 'test alt text')
        end
      end
    end
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
        expect(page).to have_content('Diffusion Map short name')
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
    select(1, from: "page_page_components_attributes_#{component_index}_component_attributes_margin_bottom")
    select(4, from: "page_page_components_attributes_#{component_index}_component_attributes_margin_top")
  end

  def fill_in_optional_page_component_image_fields(
    image_index,
    url,
    wysiwyg_editor_index,
    wysiwyg_editor_content
  )
    click_link('Add image')
    all(:field, 'Image URL')[image_index].set(url)
    within_frame(all('.tox-edit-area__iframe')[wysiwyg_editor_index]) do
      find('body').set(wysiwyg_editor_content)
    end
  end

  def fill_in_required_page_component_image_fields(image_index, alt_text)
    all('input[type="file"]')[image_index].attach_file(@image_file)
    all(:field, 'Alternative text *required*')[image_index].set(alt_text)
  end
end