require 'rails_helper'

describe 'Page Builder - Edit', type: :feature do
	before do
		page_group = PageGroup.create(			
			name: 'programming',
			slug: 'programming',
			description: 'Pages about programming go in this group.'
		)
		page = Page.create(
			page_group: page_group,
			title: 'ruby',
			description: 'what a gem',
			slug: 'ruby-rocks',
			has_chrome_warning_banner: true,
			created_at: Time.now,
			published: Time.now
		)
		component1 = PageBlockQuoteComponent.create(
			text: 'Bad computer! No! No! Go sit in the corner, and think about your life.',
			citation: 'Jake the dog'
		)

		component2 = PageBlockQuoteComponent.create(
			text: 'Sucking at something is the first step to being sorta good at something.',
			citation: 'Jake the dog'
		)
		pc1 = PageComponent.create(page: page, component: component1)
		pc2 = PageComponent.create(page: page, component: component2)

		@admin = User.create!(email: 'yuji.itadori@va.gov', first_name: 'Yuji', last_name: 'Itadori', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
		@admin.add_role(:admin)
		# must be logged in to view pages
	end
	
	context 'Move to Top button' do
		it 'moves the component to the top of the list and saves position' do
			login_as(@admin, :scope => :admin, :run_callbacks => false)
			visit '/admin/pages/1/edit'
			
			fill_in 'user_email', with: @admin.email
			fill_in 'user_password', with: 'Password123'
			click_button 'Log in'
			
			save_and_open_page

			move_to_top_buttons = all('.move-to-top')
			move_to_top_buttons[1].click

			click_button 'Update Page'

			# Verify the order on the page
			first_component = find('#PageBlockQuoteComponent_poly_0')
			second_component = find('#PageBlockQuoteComponent_poly_1')
			expect(first_component).to appear_before(second_component)

			# Click the "Update Page" button to save changes
			click_button 'Update Page'

			# # Revisit the edit page to verify persistence
			# visit '/programming/ruby-rocks/edit'
			
			# Verify the order on the page again to ensure the change is persisted
			first_component = find('#PageBlockQuoteComponent_poly_0')
			second_component = find('#PageBlockQuoteComponent_poly_1')
			expect(second_component).to appear_before(first_component)

			# Verify the database records if needed
			components = Page.find_by(slug: 'ruby-rocks').page_components.order(:position)
			expect(components[0].component.text).to eq 'Sucking at something is the first step to being sorta good at something.'
			expect(components[1].component.text).to eq 'Bad computer! No! No! Go sit in the corner, and think about your life.'
		end
	end
end