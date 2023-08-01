require 'rails_helper'

RSpec.describe PageComponentsController, type: :request do
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
            citation: 'Jake The Dog'
        )

        component2 = PageBlockQuoteComponent.create(
            text: 'Sucking at something is the first step to being sorta good at something.',
            citation: 'Jake The Dog'
        )
        PageComponent.create(page: page, component: component1)
        @page_component = PageComponent.create(page: page, component: component2)
    end

    context 'move_to_top' do
        it "should update the position of the page component to 1" do
            expect(@page_component.position).to eq(2)
            patch "/page_components/#{@page_component.id}/move_to_top"
            @page_component.reload

            expect(@page_component.position).to eq(1)
        end

        it "should respond with JSON indicating success" do
            patch "/page_components/#{@page_component.id}/move_to_top"

            expect(response.body).to include('"success":true')
        end
    end
end