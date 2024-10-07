require 'rails_helper'

describe 'Product editor - Navigation between pages', type: :feature do
  let(:product) { create(:product)}
  let!(:admin) { create(:user, :admin)}

  before do
    login_as(admin, :scope => :user, :run_callbacks => false)
  end

  it 'renders step indicators correctly' do
  	product_editor_pages = NavigationHelper::PRODUCT_EDITOR_PAGES
  	product_editor_pages.each_with_index do |page_name, index|
  		pathname = "product_#{page_name}_path"
  		visit(send(pathname.to_sym, product))
		expect(page).to have_selector('h1', text: page_name.titleize)
  		within(".usa-step-indicator__segment--current") do
  			expect(page).to have_content(page_name.titleize)
  		end
  		if index > 0
  			last_indicator = find_all('.usa-step-indicator__segment--complete').last
	  		within(last_indicator) do
	  			expect(page).to have_content(product_editor_pages[index - 1].titleize)
	  		end
	  	end
  	end
  end
end