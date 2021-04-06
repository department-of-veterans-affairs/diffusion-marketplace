require 'rails_helper'

RSpec.describe ExternalUrlValidator do
  describe 'external url validations' do
    before do
      user = User.create!(email: 'test@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
      page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
      Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', created_at: Time.now)
      @attachment = File.new("#{Rails.root}/spec/assets/acceptable_img.jpg")
    end

    context "given a URL with no protocol (e.g. http, https)" do
      it 'should add an error message' do
        component = PageImageComponent.new(page_image: @attachment, alt_text: 'alt image', url: 'www.fake-url.com')
        component.valid?
        expect(component.errors[:url][0]).to eq("Not a valid external URL")
      end
    end

    context 'given a URL with no domain extension' do
      it 'should add an error message' do
        component = PageImageComponent.new(page_image: @attachment, alt_text: 'alt image', url: 'https://www.google')
        component.valid?
        expect(component.errors[:url][0]).to eq("Not a valid external URL")
      end
    end

    context 'given a URL with http' do
      it 'should add an error message' do
        component = PageImageComponent.new(page_image: @attachment, alt_text: 'alt image', url: 'http://www.google.com')
        component.valid?
        expect(component.errors[:url][0]).to eq(nil)
      end
    end

    context 'given a URL with https' do
      it 'should have no errors' do
        component = PageImageComponent.new(page_image: @attachment, alt_text: 'alt image', url: 'https://www.google.com')
        component.valid?
        expect(component.errors[:url][0]).to eq(nil)
      end
    end

    context 'given an malformed URL' do
      it 'should have no errors' do
        component = PageImageComponent.new(page_image: @attachment, alt_text: 'alt image', url: 'https//wwwgooglecom')
        component.valid?
        expect(component.errors[:url]).to eq(["Not a valid external URL"])
      end
    end
  end
end
