require 'rails_helper'

describe 'Page Builder - Show - 1:1 Image to Text', type: :feature do
  before do
    page_group = PageGroup.create(
      name: 'programming', 
      slug: 'programming', 
      description: 'Pages about programming go in this group.',
    )
    page = Page.create(
      page_group: page_group, 
      title: 'ruby', description: 'what a gem', 
      slug: 'ruby-rocks', 
      has_chrome_warning_banner: true, 
      created_at: Time.now, 
      published: Time.now,
    )
    image_path = File.join(Rails.root, '/spec/assets/charmander.png')
    image_file = File.new(image_path)
    @one_to_one_image_component = PageOneToOneImageComponent.new(
      text: "THIS IS A CAT",
      text_alignment: 'Left',
      title: 'Image and alt text',
      image: image_file,
      image_alt_text: "Test Image",
      url: "https://example.com",
      url_link_text: "Link Text",
    )
    @one_to_one_image_component.save!

    PageComponent.create(page: page, component: @one_to_one_image_component, created_at: Time.now)
    # must be logged in to view pages
    login_as(@user, scope: :user, run_callbacks: false)
  end

  context 'Image and alt text' do
    it 'image and alt text present' do
      visit 'programming/ruby-rocks'

      expect(page).to have_css("img[src*='#{@one_to_one_image_component.image_s3_presigned_url}']")
      expect(page).to have_css("img[alt='Test Image']")
    end
  end

  context 'Text alignment' do
    it 'aligns the text to the left of the image when text_alignment is "Left"' do
      visit '/programming/ruby-rocks'
      expect(page).to have_css('.grid-item-text.order-first')
    end

    it 'aligns the text to the right of the image when text_alignment is "Right"' do
      @one_to_one_image_component.update!(text_alignment: "Right")
      visit '/programming/ruby-rocks'
      expect(page).to have_css('.grid-item-text.order-last')
    end
  end

  context 'URL' do
    it 'displays the component URL' do
      visit '/programming/ruby-rocks'
      expect(page).to have_link('Link Text', href: 'https://example.com')
    end
  end
end