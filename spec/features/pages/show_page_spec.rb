require 'rails_helper'

describe 'Page Builder - Show', type: :feature do
  before do
    user = User.create!(email: 'sandy.cheeks@va.gov', password: 'Password123',
                        password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    user.add_role(:admin)
    @practices = [
      Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'A cool practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'An awesome practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'An amazing practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'A beautiful practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'A superb practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'The last practice', approved: true, published: true, tagline: 'Test tagline', user: user)
    ]

    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    @page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    Page.create(page_group: page_group, title: 'javascript', description: 'cool stuff', slug: 'javascript', created_at: Time.now, published: Time.now)
    pr_ids = @practices.map { |pr| pr[:id].to_s }
    practice_list_component = PagePracticeListComponent.create(practices: pr_ids)
    subpage_hyperlink_component = PageSubpageHyperlinkComponent.create(url: '/programming/javascript', title: 'Check out JavaScript', description: 'It is pretty cool too')
    @image_path = File.join(Rails.root, '/spec/assets/charmander.png')
    image_file = File.new(@image_path)
    image_component = PageImageComponent.create(alignment: 'right', alt_text: 'best pokemon ever', page_image: image_file)
    image_path_2 = File.join(Rails.root, '/spec/assets/SpongeBob.png')
    image_file_2 = File.new(image_path_2)
    image_component_2 = PageImageComponent.create(alignment: 'center', alt_text: 'image with link', page_image: image_file_2, url: 'https://va.gov')
    image_path_3 = File.join(Rails.root, '/spec/assets/acceptable_img.jpg')
    image_file_3 = File.new(image_path_3)
    image_component_3 = PageImageComponent.create(alignment: 'center', alt_text: 'image with internal link', page_image: image_file_3, url: '/about')
    cta_component = PageCtaComponent.create(url: 'https://www.google.com', button_text:'Search now', cta_text: 'Curious about programming languages?')
    cta_component_internal = PageCtaComponent.create(url: '/innnovations/vione', button_text: 'Internal CTA', cta_text: 'Explore innovations')
    youtube_video_component = PageYouTubePlayerComponent.create(url: 'https://www.youtube.com/watch?v=C0DPdy98e4c', caption: 'Test Video')
    downloadable_file = File.new(File.join(Rails.root, '/spec/assets/dummy.pdf'))
    downloadable_file_component = PageDownloadableFileComponent.create(attachment: downloadable_file, description: 'Test file')
    paragraph_component = PageParagraphComponent.create(text: "<div><p><a href='https://marketplace.va.gov/about'>about the marketplace</a></p><p><a href='https://wikipedia.org/'>an external link</a></p></div>")
    legacy_paragraph_component = PageParagraphComponent.create(text: "<div><p><a href='../../about' target='_blank'>relative internal link with dot</a></p><p><a href='/about' target='_blank'>relative internal link with slash</a></p><p><a href='https://marketplace.va.gov/' target='_blank'>absolute internal link</a></p></div>")
    accordion_component = PageAccordionComponent.create(title: 'FAQ 1', text: 'FAQ 1 text')
    accordion_component_2 = PageAccordionComponent.create(title: 'FAQ 2', text: 'FAQ 2 text')

    PageComponent.create(page: @page, component: practice_list_component, created_at: Time.now)
    PageComponent.create(page: @page, component: subpage_hyperlink_component, created_at: Time.now)
    PageComponent.create(page: @page, component: image_component, created_at: Time.now)
    PageComponent.create(page: @page, component: image_component_2, created_at: Time.now)
    PageComponent.create(page: @page, component: image_component_3, created_at: Time.now)
    PageComponent.create(page: @page, component: cta_component, created_at: Time.now)
    PageComponent.create(page: @page, component: cta_component_internal, created_at: Time.now)
    PageComponent.create(page: @page, component: youtube_video_component, created_at: Time.now)
    PageComponent.create(page: @page, component: downloadable_file_component, created_at: Time.now)
    PageComponent.create(page: @page, component: paragraph_component, created_at: Time.now)
    PageComponent.create(page: @page, component: legacy_paragraph_component, created_at: Time.now)
    PageComponent.create(page: @page, component: accordion_component, created_at: Time.now)
    PageComponent.create(page: @page, component: accordion_component_2, created_at: Time.now)

    # must be logged in to view pages
    login_as(user, scope: :user, run_callbacks: false)
    visit '/programming/ruby-rocks'
  end

  it 'Should display the blue gradient banner along with the title and description, if the is_visible attr is true' do
    expect(page).to have_css('.dm-gradient-banner', visible: true)
    expect(page).to have_content('ruby')
    expect(page).to have_content('what a gem')
  end

  it 'Should not display the blue gradient banner, title, or description if the is_visible attr is false' do
    @page.update(is_visible: false)
    visit '/programming/ruby-rocks'

    expect(page).to_not have_css('.dm-gradient-banner')
    expect(page).to_not have_content('ruby')
    expect(page).to_not have_content('what a gem')
  end

  it 'Should display the practices' do
    expect(page).to have_content('A public practice')
    expect(page).to have_content('A cool practice')
    expect(page).to have_content('An awesome practice')
    expect(page).to have_content('An amazing practice')
    expect(page).to have_content('A beautiful practice')
    expect(page).to have_content('A superb practice')
    expect(page).to have_no_content('The last practice')
    expect(page).to have_css('.dm-practice-link')
    expect(page).to have_content('Load more')
    find('.dm-paginated-0-link').click
    expect(page).to have_content('The last practice')
  end

  it 'Should display the subpage hyperlink' do
    expect(find_all('.usa-link').first[:href]).to include('/programming/javascript')
    expect(page).to have_content('Check out JavaScript')
    expect(page).to have_content('It is pretty cool too')
  end

  it 'Should display the accordion component' do
    expect(page).to have_content('FAQ 1')
    expect(page).to have_css('#accordion_anchor_1')
    expect(page).to have_content('FAQ 2')
    expect(page).to have_css('#accordion_anchor_2')
  end

  it 'Should display the page image' do
    expect(page).to have_css("img[src*='charmander.png']")
    expect(page).to have_css('.flex-justify-end')
  end

  it 'should display the page image with a url' do
    expect(page).to have_css("img[src*='SpongeBob.png']")
    expect(page).to have_css('.flex-justify-center')

    # get the parent element of the image's URL
    external_link = page.find("img[src*='SpongeBob.png']").find(:xpath, '..')
    expect(external_link[:href]).to eq('https://va.gov/')
    expect(external_link[:target]).to eq('_blank')

    internal_link = page.find("img[src*='acceptable_img.jpg']").find(:xpath, '..')
    expect(URI.parse(internal_link[:href]).path).to eq('/about')
    expect(internal_link[:target]).not_to eq('_blank')
  end

  it 'Should display the call to action' do
    external_cta = page.find_link('Search now')
    expect(external_cta[:href]).to eq('https://www.google.com/')
    expect(external_cta[:target]).to eq('_blank')
    expect(page).to have_content('Curious about programming languages?')

    internal_cta = page.find_link('Internal CTA')
    expect(URI.parse(internal_cta[:href]).path).to eq('/innnovations/vione')
    expect(internal_cta[:target]).to_not eq('_blank')
  end

  it 'Should display the YouTube video' do
    expect(page).to have_css('.video-container')
    expect(page).to have_content('Test Video')
  end

  it 'Should display the downloadable file' do
    expect(page).to have_css('.usa-link--external')
    expect(page).to have_content('Test file')
  end

  it 'styles external links and opens them in a new tab' do
    internal_link = page.find_link('about the marketplace')
    external_link = page.find_link('an external link')

    expect(external_link[:class]).to eq('usa-link usa-link--external')
    expect(external_link[:target]).to eq('_blank')
    expect(internal_link[:class]).not_to eq('usa-link usa-link--external')
    expect(internal_link[:target]).not_to eq('_blank')
  end

  it 'remediates legacy internal links with incorrect target' do
    rel_link_dot = page.find_link('relative internal link with dot')
    rel_link_slash = page.find_link('relative internal link with slash')
    absolute_link = page.find_link('absolute internal link')

    expect(rel_link_dot[:target]).not_to eq('_blank')
    expect(rel_link_slash[:target]).not_to eq('_blank')
    expect(absolute_link[:target]).not_to eq('_blank')
  end

  it 'Should not display a warning banner on the Chrome browser' do
    expect(page).to_not have_content('Some links or actions on this page are not supported or optimal on this browser.')
  end

  it 'Should display a warning banner on non-Chrome browsers', js: true do
    expect(page).to have_content('Some links or actions on this page are not supported or optimal on this browser.')
  end

  it 'should allow any user to be able to visit published page-builder pages' do
    logout
    visit '/programming/ruby-rocks'

    expect(page).to_not have_current_path(root_path)
    expect(page).to have_content('ruby')
    expect(page).to have_content('what a gem')
  end

  it 'should allow admins to toggle card styling for link components' do
    expect(page).to_not have_selector('.pb-link-card')
    expect(page).to have_selector('.pb-link-default')

    visit '/admin/pages'
    all('.edit_link').last.click
    expect(page).to have_content('ADD CARD STYLING')
    expect(page).to have_css('.toggle-card-styling')
    # scroll down the page so the 'Add card styling' checkbox is visible
    scroll_to(0, 1500)
    check('Add card styling')
    find('#page_submit_action_1').click
    expect(page).to have_content('Page was successfully updated.')
    visit '/programming/ruby-rocks'

    expect(page).to_not have_selector('.pb-link-default')
    expect(page).to have_selector('.pb-two-column-card-link-container')
    expect(page).to have_selector('.pb-link-card')
  end

  context 'CompoundBodyComponents and associated PageComponentImages' do
    it 'should be visible and configured correctly based on user input' do
      visit edit_admin_page_path(Page.last)
      # Add a CompoundBodyComponent and fill in fields
      add_compound_body_component_and_fill_in_fields
      find_all('input[type="submit"]').first.click
      expect(page).to have_content('Page was successfully updated.')
      # With no PageComponentImages present, the CompoundBodyComponent text should take up six columns
      visit '/programming/javascript'
      expect(page).to have_selector('div.page-compound-body-component.margin-bottom-0.margin-top-4')
      within(:css, '.page-compound-body-component') do
        expect(find('.grid-item-text').matches_style?('grid-column' => '1 / 7')).to be(true)
        expect(page).to have_selector('h2', class: 'usa-prose-h2')
        expect(page).to have_text('Cool Title')
        expect(page).to have_text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
      end
      # Edit the existing CompoundBodyComponent and add a PageComponentImage
      visit edit_admin_page_path(Page.last)
      # Add larger title, change the text alignment, and added a URL and URL link text
      find('#page_page_components_attributes_0_component_attributes_large_title').click
      select('Right', from: 'page_page_components_attributes_0_component_attributes_text_alignment')
      fill_in('page_page_components_attributes_0_component_attributes_url', with: '/')
      fill_in('page_page_components_attributes_0_component_attributes_url_link_text', with: 'A link to the homepage')
      # Add image
      add_page_component_image_to_component(
        '#PageCompoundBodyComponent_poly_0',
      @image_path,
        '/search',
        'Some cool caption',
        'A cute charmander'
      )
      find_all('input[type="submit"]').first.click
      expect(page).to have_content('Page was successfully updated.')
      # With one PageComponentImage present, the CompoundBodyComponent text should now only take up five columns.
      # The associated PageComponentImage should take up four columns.
      visit '/programming/javascript'
      expect(page).to be_accessible.according_to :wcag2a, :section508
      # Make sure the updated CompoundBodyComponent fields are represented
      within(:css, '.page-compound-body-component') do
        # Right-aligned text
        expect(page).to have_selector('div.grid-item-text.right-align')
        # Five columns worth of text, but on the right side of the grid now
        expect(find('.grid-item-text').matches_style?('grid-column' => '8 / 13')).to be(true)
        # The larger title gets 'h1' styling
        expect(page).to have_selector('h2', class: 'usa-prose-h1')
        # Link with link text
        expect(page).to have_link('A link to the homepage', href: '/')
        # Make sure the new PageComponentImage is present and any completed fields are displayed
        expect(page).to have_selector('div.grid-item-images.left-align')
        within(:css, '.image-container') do
          expect(find('img')['src']).to include('charmander.png')
          expect(find('img')['alt']).to eq('A cute charmander')
          expect(page).to have_link(href: '/search')
          expect(page).to have_text('Some cool caption')
        end
      end
    end

    context 'mobile view' do
      before do
        page.driver.browser.manage.window.resize_to(340, 580)
      end

      it 'should display the text and images correctly based on the designs (as of 9/20/22)' do
        visit edit_admin_page_path(Page.last)
        # Add a CompoundBodyComponent and fill in fields
        add_compound_body_component_and_fill_in_fields
        find_all('input[type="submit"]').first.click
        expect(page).to have_content('Page was successfully updated.')
        # With no PageComponentImages present, the CompoundBodyComponent text should take up all twelve columns
        # and only one row
        visit '/programming/javascript'
        within(:css, '.page-compound-body-component') do
          expect(find('.grid-item-text').matches_style?('grid-column' => '1 / 13')).to be(true)
          expect(find('.grid-item-text').matches_style?('grid-row' => '1 / 1')).to be(true)
        end
        # Add a PageComponentImage to the existing CompoundBodyComponent
        visit edit_admin_page_path(Page.last)
        add_page_component_image_to_component(
          '#PageCompoundBodyComponent_poly_0',
          @image_path,
          '/about',
          'An awesome caption',
          'A wild charmander'
        )
        find_all('input[type="submit"]').first.click
        expect(page).to have_content('Page was successfully updated.')
        # With a PageComponentImage present, the image (and caption, if present as well) should sit on top of the
        # CompoundBodyComponent text, which means the image should now be on the first row (above) and the text on the second (below).
        # The image (and caption, if present) should take up twelve columns
        visit '/programming/javascript'
        expect(page).to be_accessible.according_to :wcag2a, :section508
        within(:css, '.page-compound-body-component') do
          # Image above
          expect(find('.grid-item-images').matches_style?('grid-column' => '1 / 13')).to be(true)
          expect(find('.grid-item-images').matches_style?('grid-row' => '1 / 2')).to be(true)
          # Text below
          expect(find('.grid-item-text').matches_style?('grid-column' => '1 / 13')).to be(true)
          expect(find('.grid-item-text').matches_style?('grid-row' => '2 / 2')).to be(true)
        end
      end
    end
  end

  def add_compound_body_component_and_fill_in_fields
    click_link('Add New Page component')
    select('Text and Images', from: 'page_page_components_attributes_0_component_type')
    fill_in("page_page_components_attributes_0_component_attributes_title", with: 'Cool Title')
    within_frame(all('.tox-edit-area__iframe')[0]) do
      find('body').set('Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
    end
    select(0, from: 'page_page_components_attributes_0_component_attributes_margin_bottom')
    select(4, from: 'page_page_components_attributes_0_component_attributes_margin_top')
  end

  def add_page_component_image_to_component(
    component_li_id,
    image_path,
    image_url,
    image_caption,
    image_alt_text
  )
    within(:css, component_li_id) do
      click_link('Add image')
      find('input[type="file"]').attach_file(image_path)
      fill_in('Image URL', with: image_url)
      within_frame(all('.tox-edit-area__iframe')[1]) do
        find('body').set(image_caption)
      end
      fill_in('Alternative text *required*', with: image_alt_text)
    end
  end
end
