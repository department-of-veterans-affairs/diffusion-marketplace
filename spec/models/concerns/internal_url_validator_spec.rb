require 'rails_helper'

RSpec.describe InternalUrlValidator do
  describe 'internal url validations' do
    before do
      Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
      page_group = PageGroup.create(name: 'programming', slug: 'programming', description: 'Pages about programming go in this group.')
      Page.create(page_group: page_group, title: 'ruby', description: 'what a gem', slug: 'ruby-rocks', created_at: Time.now)
    end

    context 'given a non-existant URL' do
      it 'should add an error message' do
        component = PageSubpageHyperlinkComponent.new(url: '/fake-url')
        component.valid?
        expect(component.errors[:url][0]).to eq("No route matches \"/fake-url\"")
      end
    end

    context 'given a URL with no "/" in the beginning' do
      it 'should add an error message' do
        component = PageSubpageHyperlinkComponent.new(url: 'practices/vione')
        component.valid?
        expect(component.errors[:url][0]).to eq("must begin with a \"/\"")
      end
    end

    context 'given a practice URL with non-existant practice' do
      it 'should add an error message' do
        component = PageSubpageHyperlinkComponent.new(url: '/practices/a-private-practice')
        component.valid?
        expect(component.errors[:url][0]).to eq("not a valid URL")
      end
    end

    context 'given a practice URL with an existing practice' do
      it 'should have no errors' do
        component = PageSubpageHyperlinkComponent.new(url: '/practices/a-public-practice')
        component.valid?
        expect(component.errors[:url]).to eq([])
      end
    end

    context 'given a subpage URL' do
      it 'should have no errors' do
        component = PageSubpageHyperlinkComponent.new(url: '/programming/ruby-rocks')
        component.valid?
        expect(component.errors[:url]).to eq([])
      end
    end
  end
end