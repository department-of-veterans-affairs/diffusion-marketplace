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
    @visn_1 = Visn.create!(name: 'VISN 1', number: 1)
    @visn_8 = Visn.create!(name: 'VISN 8', number: 8)
    @fac_1 = VaFacility.create!(
        visn: @visn_1,
        station_number: "402GA",
        official_station_name: "Caribou VA Clinic",
        common_name: "Caribou",
        latitude: "44.2802701",
        longitude: "-69.70413586",
        street_address_state: "ME",
        rurality: "R",
        fy17_parent_station_complexity_level: "1c-High Complexity",
        station_phone_number: "207-623-2123 x"
    )
    @fac_2 = VaFacility.create!(
      visn: @visn_8,
      station_number: '12345',
      official_station_name: "James A. Haley Veterans' Hospital",
      common_name: 'Tampa',
      latitude: '27.9641570',
      longitude: '-82.4526060',
      street_address_state: 'FL',
      rurality: 'U',
      fy17_parent_station_complexity_level: '1c-High Complexity',
      station_phone_number: '123-456-7890'
    )
    @fac_3 = VaFacility.create!(
      visn: @visn_8,
      station_number: '73478',
      official_station_name: "Orlando VA Medical Center",
      common_name: 'Orlando',
      latitude: '28.36668938',
      longitude: '-81.27646415',
      street_address_state: 'FL',
      rurality: 'U',
      fy17_parent_station_complexity_level: '1a-High Complexity',
      station_phone_number: '123-456-7890'
    )

    dh_1 = DiffusionHistory.create!(practice: @practices[0], va_facility: @fac_1)
    DiffusionHistoryStatus.create!(diffusion_history: dh_1, status: 'Completed')
    dh_2 = DiffusionHistory.create!(practice: @practices[5], va_facility: @fac_2)
    DiffusionHistoryStatus.create!(diffusion_history: dh_2, status: 'Completed')
    dh_3 = DiffusionHistory.create!(practice: @practices[6], va_facility: @fac_3)
    DiffusionHistoryStatus.create!(diffusion_history: dh_3, status: 'In progress')

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
    map_component = PageMapComponent.create(title: "test map", map_info_window_text: "map info window text", description: "map description", practices: [1, 2, 3], display_successful_adoptions: true, display_in_progress_adoptions: true, display_unsuccessful_adoptions: true)
    accordion_component = PageAccordionComponent.create(title: 'FAQ 1', text: 'FAQ 1 text')
    @accordion_component_2 = PageAccordionComponent.create(title: 'FAQ 2', text: 'FAQ 2 text')
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
    PageComponent.create(page: @page, component: map_component, created_at: Time.now)
    PageComponent.create(page: @page, component: accordion_component, created_at: Time.now)
    PageComponent.create(page: @page, component: @accordion_component_2, created_at: Time.now)
    ENV['GOOGLE_API_KEY'] = ENV['GOOGLE_TEST_API_KEY']
    Rails.cache.clear
    # must be logged in to view pages
    login_as(user, scope: :user, run_callbacks: false)
    visit '/programming/ruby-rocks'
  end

  after do
    ENV['GOOGLE_API_KEY'] = nil
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
    expect(page).to have_css('.dm-practice-link-aria-hidden')
    expect(page).to have_content('Load more')
    find('.dm-paginated-practices-0-link').click
    expect(page).to have_content('The last practice')
  end

  it 'should display the map' do
    expect(page).to have_content('test map')
    expect(page).to have_content('map description')
    expect(html).to have_selector('div.grid-col-12')
  end

  it 'Should display the subpage hyperlink' do
    expect(find_all('.usa-link').first[:href]).to include('/programming/javascript')
    expect(page).to have_content('Check out JavaScript')
    expect(page).to have_content('It is pretty cool too')
  end

  it 'should display banner when unpublished' do
    @page.update(published: false)
    visit '/programming/ruby-rocks'

    expect(page).to have_content("This page is not visible because it is not published")
  end

  context 'PageAccordionComponent' do
    it 'should display properly' do
      expect(page).to have_content('FAQ 1')
      expect(page).to have_css('#accordion_anchor_1')
      expect(page).to have_content('FAQ 2')
      expect(page).to have_css('#accordion_anchor_2')
    end

    it "should display the bordered styling if the 'has_border' attribute is truthy" do
      @accordion_component_2.update(has_border: true)
      visit '/programming/ruby-rocks'
      within(all('.page-accordion-component').last) do
        expect(page).to have_css('.usa-accordion--bordered')
      end
    end
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

  it 'should allow any user to be able to visit published and public page-builder pages' do
    @page.update!(is_public: true)
    logout
    visit '/programming/ruby-rocks'

    expect(page).to_not have_current_path(root_path)
    expect(page).to have_content('ruby')
    expect(page).to have_content('what a gem')
  end

  it 'should disallow a non-logged in user from visiting a non-public page' do
    logout
    visit '/programming/ruby-rocks'

    expect(page).to have_current_path(root_path)
  end

  it 'should allow admins to toggle card styling for link components' do
    expect(page).to_not have_selector('.subpage-hyperlink-component-link-card')
    expect(page).to have_selector('.subpage-hyperlink-component-link-default')

    visit '/admin/pages'
    all('.edit_link').last.click
    expect(page).to have_content('ADD CARD STYLING')
    expect(page).to have_css('.toggle-card-styling')
    # scroll down the page so the 'Add card styling' checkbox is visible
    scroll_to(0, 1500)
    check('Add card styling')
    save_page
    expect(page).to have_content('Page was successfully updated.')
    visit '/programming/ruby-rocks'

    expect(page).to_not have_selector('.subpage-hyperlink-component-link-default')
    expect(page).to have_selector('.pb-two-column-card-link-container')
    expect(page).to have_selector('.subpage-hyperlink-component-link-card')
  end

  context 'Page image and alt text' do
    it 'should display the Page image and its alt text within the blue gradient banner header' do
      visit edit_admin_page_path(Page.last)
      within(:css, '#page_image_input') do
        find('input[type="file"]').attach_file(@image_path)
      end
      fill_in('Image alternative text (required if image present)', with: 'Descriptive alt text')
      save_page

      expect(page).to have_content('Page was successfully updated.')
      visit '/programming/javascript'

      # Make sure the 'gradient-banner-with-image' class was added to the banner section
      expect(page).to have_css('.gradient-banner-with-image')
      within(:css, '.gradient-banner-with-image') do
        expect(page).to have_css("img[src*='#{Page.last.image_s3_presigned_url}']")
        expect(page).to have_css("img[alt*='#{Page.last.image_alt_text}']")
      end
    end
  end

  context 'PageMapComponent' do
    it 'should allow the user to have multiple map components on a single page' do
      visit edit_admin_page_path(Page.last)
      # Add one map
      add_map_component_and_fill_in_fields(0, 'Amazing Map', 'Amazing')
      select(@practices[0].name, from: 'page_page_components_attributes_0_component_attributes_map')
      # Add a second one
      add_map_component_and_fill_in_fields(1, 'Spectacular Map', 'Spectacular')
      select(@practices[5].name, from: 'page_page_components_attributes_1_component_attributes_map')
      select(@practices[6].name, from: 'page_page_components_attributes_1_component_attributes_map')
      save_page
      expect(page).to have_content('Page was successfully updated.')

      visit '/programming/javascript'
      # Make sure the map components are 508 compliant

      expect(page).to be_accessible.according_to :wcag2a, :section508
      expect(page).to have_css('.page-map-component', count: 2)
      within(all('.page-map-component').first) do
        expect_marker_ct(1)
      end
      within(all('.page-map-component').last) do
        expect_marker_ct(2)
      end
    end
  end

  def add_map_component_and_fill_in_fields(index, title, info_window_text)
    click_link('Add New Page component')
    select('Google Map', from: "page_page_components_attributes_#{index}_component_type")
    fill_in("page_page_components_attributes_#{index}_component_attributes_title", with: title)
    fill_in("page_page_components_attributes_#{index}_component_attributes_map_info_window_text", with: info_window_text)
    find("#page_page_components_attributes_#{index}_component_attributes_display_successful_adoptions").set(true)
    find("#page_page_components_attributes_#{index}_component_attributes_display_in_progress_adoptions").set(true)
    find("#page_page_components_attributes_#{index}_component_attributes_display_unsuccessful_adoptions").set(true)
  end

  def save_page
    find_all('input[type="submit"]').first.click
  end

  def expect_marker_ct(count)
    marker_div = 'div[style*="width: 34px"][role="button"]'
    expect(page).to have_selector(marker_div, visible: true)
    marker_count = find_all(:css, marker_div).count
    expect(marker_count).to be(count)
  end
end
