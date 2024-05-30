require 'rails_helper'

describe 'Communities', type: :feature, js:true do
	let!(:approved_community) { create(:community) }
	let!(:non_community_pagegroup) { create(:page_group, name: "Competitions", slug: 'competitions', description: "not a community") }
	let!(:community_landing_page) { create(:page, page_group: approved_community, title: 'Community homepage', description: 'cool stuff', slug: 'home', created_at: Time.now, is_public: true, published: Time.now) }
	let!(:non_community_landing_page) { create(:page, page_group: non_community_pagegroup, title: 'Competitions open call', description: 'not a community', slug: 'home', created_at: Time.now, is_public: true, published: Time.now) }
	let!(:community_subpage) { create(:page, page_group: approved_community, title: 'Community about page', description: 'about us', slug: 'about', created_at: Time.now, is_public: true, published: Time.now, short_name: 'About') }

	describe 'subnav' do
		it 'does not render for a page that is not a community page' do
			visit page_show_path(non_community_pagegroup.slug, non_community_landing_page.slug)
			expect(page).not_to have_css('#community-subnav')
		end

		context 'published homepage' do
			it 'is rendered for pages that are community pages' do
				visit('/communities/va-immersive')
				expect(page).to have_css('#community-subnav')
				within('#community-subnav') do
					expect(page).to have_content('Community')
					expect(page).to have_content('About')
				end
			end

			it 'only shows pages that exist and have been published' do
				another_subpage = Page.create(page_group: approved_community, title: 'Community Events and News page', description: 'events and news', slug: 'events-and-news', created_at: Time.now, is_public: true, published: Time.now)
				visit('/communities/va-immersive/about')
				within('#community-subnav') do
					expect(page).to have_content('About')
					expect(page).to have_link('About', class: 'current-page')
					expect(page).to have_content('Events and News')
					expect(page).to have_link('Events and News')
					expect(page).not_to have_content('Publications')
				end
			end
		end

		context 'unpublished homepage' do
			it 'renders all approved subpages regardless of publication status' do
				community_landing_page.update(published: nil)
				unpublished_subpage = Page.create(page_group: approved_community, title: 'Publications', description: 'approved subpage', slug: 'publications', created_at: Time.now, is_public: true, published: nil)
				visit('/communities/va-immersive/about')
				within('#community-subnav') do
					expect(page).to have_link('About', class: 'current-page')
					expect(page).to have_link('Publications')
				end
			end
		end
	end
end