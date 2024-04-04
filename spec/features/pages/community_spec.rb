require 'rails_helper'

describe 'Communities', type: :feature, js:true do
	before do
		@approved_community = PageGroup.create(name: 'VA Immersive', slug: 'va-immersive', description: "approved community")
		@non_community_pagegroup = PageGroup.create(name: "Competitions", slug: 'competitions', description: "not a community")
		@community_landing_page = Page.create(page_group: @approved_community, title: 'Community homepage', description: 'cool stuff', slug: 'home', created_at: Time.now, is_public: true, published: Time.now)		
		@non_community_landing_page = Page.create(page_group: @non_community_pagegroup, title: 'Competitions open call', description: 'not a community', slug: 'home', created_at: Time.now, is_public: true, published: Time.now)
	end

	context 'subnav' do
		it 'is rendered for approved communities' do
			visit('/communities/va-immersive')
			expect(page).to have_css('#community-subnav')
			within('#community-subnav') do
				expect(page).to have_content('Community')
				expect(page).not_to have_content('About')
			end
		end

		it 'only shows pages that exist' do
			community_subpage = Page.create(page_group: @approved_community, title: 'Community about page', description: 'about us', slug: 'about', created_at: Time.now, is_public: true, published: Time.now)
			visit('/communities/va-immersive')
			within('#community-subnav') do
				expect(page).to have_content('About')
				expect(page).to have_link('About', css: '.current-page')
				expect(page).not_to have_content('Events and News')
			end
		end

		it 'does not render for generic pagegroups' do
			visit page_show_path(@non_community_pagegroup.slug, @non_community_landing_page.slug)
			expect(page).not_to have_css('#community-subnav')
		end
	end
end