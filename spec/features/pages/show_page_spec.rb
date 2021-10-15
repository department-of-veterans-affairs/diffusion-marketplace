require 'rails_helper'

describe 'Page Builder - Show', type: :feature do
  before do
    user = User.create!(email: 'sandy.cheeks@va.gov', password: 'Password123',
                        password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    user.add_role(:admin)
    @practices = [
      Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline', user: user),
      Practice.create!(name: 'A cool practice', approved: true, published: true, tagline: 'Test tagline', user: user)
    ]
    page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
    page = Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', has_chrome_warning_banner: true, created_at: Time.now, published: Time.now)
    Page.create(page_group: page_group, title: 'javascript', description: 'cool stuff', slug: 'javascript', created_at: Time.now, published: Time.now)
    practice_list_component = PagePracticeListComponent.create(practices: [@practices[0][:id].to_s, @practices[1][:id].to_s,])
    subpage_hyperlink_component = PageSubpageHyperlinkComponent.create(url: '/programming/javascript', title: 'Check out JavaScript', description: 'It is pretty cool too')
    image_path = File.join(Rails.root, '/spec/assets/charmander.png')
    image_file = File.new(image_path)
    image_component = PageImageComponent.create(alignment: 'right', alt_text: 'best pokemon ever', page_image: image_file)
    image_path_2 = File.join(Rails.root, '/spec/assets/SpongeBob.png')
    image_file_2 = File.new(image_path_2)
    image_component_2 = PageImageComponent.create(alignment: 'center', alt_text: 'image with link', page_image: image_file_2, url: 'https://va.gov')
    cta_component = PageCtaComponent.create(url: 'https://www.google.com', button_text:'Search now', cta_text: 'Curious about programming languages?')
    youtube_video_component = PageYouTubePlayerComponent.create(url: 'https://www.youtube.com/watch?v=C0DPdy98e4c', caption: 'Test Video')
    downloadable_file = File.new(File.join(Rails.root, '/spec/assets/dummy.pdf'))
    downloadable_file_component = PageDownloadableFileComponent.create(attachment: downloadable_file, description: 'Test file')
    PageComponent.create(page: page, component: practice_list_component, created_at: Time.now)
    PageComponent.create(page: page, component: subpage_hyperlink_component, created_at: Time.now)
    PageComponent.create(page: page, component: image_component, created_at: Time.now)
    PageComponent.create(page: page, component: image_component_2, created_at: Time.now)
    PageComponent.create(page: page, component: cta_component, created_at: Time.now)
    PageComponent.create(page: page, component: youtube_video_component, created_at: Time.now)
    PageComponent.create(page: page, component: downloadable_file_component, created_at: Time.now)
    # must be logged in to view pages
    login_as(user, scope: :user, run_callbacks: false)
    visit '/programming/ruby-rocks'
  end

  it 'Should display the title and description' do
    expect(page).to have_content('ruby')
    expect(page).to have_content('what a gem')
  end

  it 'Should display the practices' do
    expect(page).to have_content('A public practice')
    expect(page).to have_content('A cool practice')
    expect(page).to have_css('.dm-practice-link')
  end

  it 'Should display the subpage hyperlink' do
    expect(find_all('.usa-link').first[:href]).to include('/programming/javascript')
    expect(page).to have_content('Check out JavaScript')
    expect(page).to have_content('It is pretty cool too')
  end

  it 'Should display the page image' do
    expect(page).to have_css("img[src*='charmander.png']")
    page.should have_css('.flex-justify-end')
  end

  it 'should display the page image with a url' do
    expect(page).to have_css("img[src*='SpongeBob.png']")
    page.should have_css('.flex-justify-center')

    # get the parent element of the image's URL
    link = page.find("img[src*='SpongeBob.png']").find(:xpath, '..')
    link[:href].should == "https://va.gov/"
  end

  it 'Should display the call to action' do
    expect(find_all('.usa-button').last[:href]).to include('https://www.google.com')
    expect(page).to have_content('Curious about programming languages?')
    expect(page).to have_content('Search now')
  end

  it 'Should display the YouTube video' do
    expect(page).to have_css('.video-container')
    expect(page).to have_content('Test Video')
  end

  it 'Should display the downloadable file' do
    expect(page).to have_css('.usa-link--external')
    expect(page).to have_content('Test file')
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
end
