require 'rails_helper'

RSpec.describe PageController, type: :request do
  describe 'show' do
    before do
      @page_group = create(:page_group, name: 'va-immersive', description: 'Pages about programming go in this group.') 
      create(:page, slug: 'home', page_group: @page_group, is_public: true) 
      create(:page, slug: 'events-and-news', page_group: @page_group, is_public: true) 
    end

    context 'public pages' do
      it "should redirect the user with a prepended '/communities' to the URL if the Page is a community page and the URL doesn't include '/communities'" do
        get '/va-immersive'
        expect(response.header['Location']).to include('/communities/va-immersive')

        get '/va-immersive/events-and-news'
        expect(response.header['Location']).to include('/communities/va-immersive/events-and-news')
      end
    end

    context 'non-public pages' do
      before do
        create(:page, slug: 'va-users-only', page_group: @page_group, is_public: false)
      end

      it 'should prevent a non-logged in user from accessing' do
        get '/va-immersive/va-users-only'
        expect(flash[:warning]).to eq('You are not authorized to view this content.')
        expect(response).to redirect_to(root_path)
      end

      it 'should allow access for a logged-in user' do
        user = create(:user)
        login_as(user, :scope => :user, :run_callbacks => false)

        get '/va-immersive/va-users-only'
        expect(response.header['Location']).to include('/communities/va-immersive/va-users-only')
      end
    end
  end
end
