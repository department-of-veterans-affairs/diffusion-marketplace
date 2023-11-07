require 'rails_helper'

RSpec.describe PageController, type: :request do
  before do
    page_group = PageGroup.create!(
      name: 'va-immersive',
      description: 'Pages about programming go in this group.'
    )
    Page.create!(
      title: 'VA Immersive Home',
      description: 'This is a homepage',
      slug: 'home',
      page_group: page_group,
      published: Time.now
    )
    Page.create!(
      title: 'VA Immersive Events nad News',
      description: 'This is an events page',
      slug: 'events-and-news',
      page_group: page_group,
      published: Time.now
    )
  end

  context 'show' do
    it "should redirect the user with a prepended '/communities' to the URL if the Page is a community page "\
      "and the URL doesn't include '/communities'" do
      get '/va-immersive'
      # For some reason on CI, an ID gets appended to the sample domain (e.g. 'http://www.example.com482c087b40dc/communities/va-immersive').
      # To circumvent this issue, we can just check to make sure that the response header 'Location' includes '/communities'
      expect(response.header['Location']).to include('/communities/va-immersive')

      get '/va-immersive/events-and-news'
      expect(response.header['Location']).to include('/communities/va-immersive/events-and-news')
    end
  end
end