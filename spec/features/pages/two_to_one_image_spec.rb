require 'rails_helper'
  describe 'Page Builder - Show - 2:1 Image to Text', type: :feature do
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
    @two_to_one_image_component = PageTwoToOneImageComponent.new(
      title: 'Image and alt text',
      image: image_file,
      image_alt_text: "Test Image"
    )
    @two_to_one_image_component.save!

    PageComponent.create(page: page, component: @two_to_one_image_component, created_at: Time.now)
    # must be logged in to view pages
    login_as(@user, scope: :user, run_callbacks: false)
  end

  context 'Text alignment' do
    it 'aligns text to right if specified' do
      @two_to_one_image_component.update!(
        title: 'Text alignment test', 
        text_alignment: 'Right',
        text: 'This is some sample text',
      )

      visit 'programming/ruby-rocks'

      expect(page).to have_css('.grid-item-text.right-align')
    end
  end

  context 'Image and alt text' do
    it 'image and alt text present' do
      visit 'programming/ruby-rocks'

      expect(page).to have_css("img[src*='#{@two_to_one_image_component.image_s3_presigned_url}']")
      expect(page).to have_css("img[alt='Test Image']")
    end
  end
end