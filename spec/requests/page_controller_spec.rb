require 'rails_helper'

RSpec.describe PageController, type: :request do
  before do
    page_group = PageGroup.create!(
      name: 'xr-network',
      description: 'Pages about programming go in this group.'
    )
    Page.create!(
      title: 'XR Network Home',
      description: 'This is a homepage',
      slug: 'home',
      page_group: page_group,
      published: Time.now
    )
    Page.create!(
      title: 'XR Network Events',
      description: 'This is an events page',
      slug: 'events',
      page_group: page_group,
      published: Time.now
    )
  end

  context 'show' do
    it "should redirect the user with a prepended '/communities' to the URL if the Page is a community page "\
      "and the URL doesn't include '/communities'" do
      get '/xr-network'
      expect(response).to redirect_to('/communities/xr-network')

      get '/xr-network/events'
      expect(response).to redirect_to('/communities/xr-network/events')
    end
  end
end