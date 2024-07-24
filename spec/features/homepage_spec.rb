require 'rails_helper'

describe 'Homepage', type: :feature do
  before do
    visn_8 = create(:visn, id: 7, name: "VA Sunshine Healthcare Network", number: 8)
    visn_9 = create(:visn, id: 8, name: "VA MidSouth Healthcare Network", number: 9)

    create(:va_facility, visn: visn_8, station_number: "673", official_station_name: "James A. Haley Veterans' Hospital", common_name: "Tampa-Florida", street_address_state: "FL")
    create(:va_facility, visn: visn_9, station_number: "614", official_station_name: "Memphis VA Medical Center", common_name: "Memphis", street_address_state: "TN")

    @user = create(:user, :admin, email: 'naofumi.iwatani@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)

    create(:practice, name: 'Project HAPPEN', slug: 'project-happen', is_public: true, approved: true, published: true, tagline: "HAPPEN tagline", date_initiated: 'Sun, 04 Feb 1992 00:00:00 UTC +00:00', created_at: 'Sun, 04 Feb 1992 00:00:00 UTC +00:00', support_network_email: 'contact-happen@happen.com', user: @user)
    @practice = create(:practice, name: 'The Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', created_at: 'Sun, 05 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', is_public: true, published: true, approved: true, user: @user)
    @practice_2 = create(:practice, name: 'The Second Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 06 Feb 1992 00:00:00 UTC +00:00', created_at: 'Sun, 06 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', is_public: true, published: true, approved: true, user: @user)
    @practice_3 = create(:practice, name: 'The Third Best Practice Ever!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 07 Feb 1992 00:00:00 UTC +00:00', created_at: 'Sun, 07 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', is_public: true, published: true, approved: true, user: @user)
    @va_only_practice = create(:practice, name: 'Recent VA-only practice!', initiating_facility_type: 'facility', tagline: 'Test tagline', date_initiated: 'Sun, 08 Feb 1992 00:00:00 UTC +00:00', created_at: 'Sun, 07 Feb 1992 00:00:00 UTC +00:00', summary: 'This is the best practice ever.', overview_problem: 'overview-problem', is_public: false, published: true, approved: true, user: @user)

    create(:practice_origin_facility, practice: @practice, facility_type: 0, va_facility_id: 1)

    @featured_image = "#{Rails.root}/spec/assets/charmander.png"
    @parent_cat = create(:category, name: 'First Parent Category')
    @parent_cat_b = create(:category, name: 'Communities')
    @cat_1 = create(:category, name: 'COVID', parent_category: @parent_cat)
    @cat_2 = create(:category, name: 'Telehealth', parent_category: @parent_cat)
    @cat_3 = create(:category, name: 'VA Immersive', parent_category: @parent_cat_b)

    create(:category_practice, practice: @practice, category: @cat_1)
    create(:category_practice, practice: @practice_2, category: @cat_2)
    create(:category_practice, practice: @practice_3, category: @cat_1)
    create(:category_practice, practice: @practice_3, category: @cat_3)

    ampersand_practice = create(:practice, name: 'Coaching & More', slug: 'coaching-and-more', is_public: true, approved: true, published: true, tagline: "HAPPEN tagline", date_initiated: 'Sun, 04 Feb 1992 00:00:00 UTC +00:00', created_at: 'Sun, 04 Feb 1992 00:00:00 UTC +00:00', support_network_email: 'contact-happen@happen.com', user: @user)
    ampersand_category = create(:category, name: 'Nutrition & Food', parent_category: @parent_cat)
    create(:category_practice, practice: ampersand_practice, category: ampersand_category)

    visit '/'
  end

  it 'links to the Shark Tank page' do
    expect(page).to have_link(href: '/competitions/shark-tank')
  end

  describe 'search section' do
    it 'should allow the user to search for practices in a number of ways' do
      expect(page).to be_accessible.according_to :wcag2a, :section508

      # search for a practice using the search field
      fill_in('dm-homepage-search-field', with: 'James A. Haley')
      find('#dm-homepage-search-button').click

      expect(page).to have_content('1 Result:')
      expect(page).to have_content(@practice.name)
    end
  end

  it 'invites users to submit innovations' do
    within('#main-content') do
      expect(page).to have_content('Submit Innovations')
      expect(page).to have_link('Nominate', href: nominate_an_innovation_path)
    end
  end

  it 'allows the user to subscribe to the DM newsletter by taking them to the GovDelivery site' do
    fill_in('Your email address', with: 'vladilena.milize@test.com')

    new_window = window_opened_by { click_button('Subscribe') }

    within_window new_window do
      wait_time = Capybara.default_max_wait_time
      start_time = Time.now

      loop do
        current_url_matches = (current_url == 'https://public.govdelivery.com/accounts/USVHA/subscribers/qualify')
        break if current_url_matches || (Time.now - start_time) > wait_time

        sleep 0.1
      end

      expect(current_url).to eq('https://public.govdelivery.com/accounts/USVHA/subscribers/qualify')
    end
  end

  describe 'search dropdown functionality' do
    before do
      find('#dm-homepage-search-field').click
    end

    it 'lists most recently created innovations' do
      within '#practice-list' do
        expect(page).to have_content('The Best Practice Ever!')
        expect(page).to have_content('The Second Best Practice Ever!')
        expect(page).to have_content('The Third Best Practice Ever!')

        expect(page).not_to have_content('Project HAPPEN') # oldest practice
        expect(page).not_to have_content('Recent VA-only practice!') # private practice
      end
    end

    it 'shows VA-only innovations to logged in users' do
      login_as(@user, scope: :user, run_callbacks: false)
        visit '/'
        find('#dm-homepage-search-field').click

        expect(page).to have_content('Recent VA-only practice!')
        expect(page).to have_content('The Second Best Practice Ever!')
        expect(page).to have_content('The Third Best Practice Ever!')
    end

    it 'lists popular categories' do
      within '#category-list' do
        expect(page).to have_content('COVID')
        expect(page).to have_content('Telehealth')
      end
    end

    it 'lets a user search for innovations' do
      fill_in('dm-homepage-search-field', with: 'HAPPEN')
      within '#search-dropdown' do
        expect(page).to have_link('Project HAPPEN', href: '/innovations/project-happen')
      end
    end

    it 'should navigate to search page with category filter when a category is clicked' do
      within '#category-list' do
        expect(page).to have_link('COVID', href: '/search?category=COVID')
      end
    end

    describe 'links to the search page', js: true do
      it 'provides a link to the search page' do
        within '#search-dropdown' do
          expect(page).to have_link('Browse all Innovations', href: '/search')
        end
      end

      it 'provides a link that navs to the search page with the filters accordian engaged' do
        within '#search-dropdown' do
          expect(page).to have_link('Browse all Tags', href: '/search')
          click_link 'Browse all Tags'
        end
        expect(page).to have_current_path('/search')
      end

      it 'provides a link that navs to the search page with all community tags engaged' do
        within '#search-dropdown' do
          expect(page).to have_link('Browse all Community Innovations', href: '/search?all_communities=true')
          click_link 'Browse all Community Innovations'
        end
        expect(page).to have_content("1 Result:")
        expect(page).to have_content(@practice_3.name)
      end
    end

    it 'lets a user navigate results with arrow keys' do
      page.send_keys :down, :down, :down, :down, :down # navigate to first category
      page.send_keys :enter # select category
      expect(page).to have_current_path('/search?category=COVID')
      expect(page).to have_content("2 Results: TAG: COVID")
    end

    it 'encodes categories & innovations with ampersands' do
      fill_in('dm-homepage-search-field', with: '&')
      expect(page).to have_link('Nutrition & Food', href: '/search?category=Nutrition%20%26%20Food')
      expect(page).to have_link('Coaching & More', href: '/innovations/coaching-and-more')
    end

    it 'tracks clicks on practice links' do
      event = wait_for_ahoy_js('The Best Practice Ever!')

      expect(event.name).to eq("Dropdown Practice Link Clicked")
      expect(event.properties["practice_name"]).to eq("The Best Practice Ever!")
      expect(event.properties["from_homepage"]).to be_truthy
    end

    it 'tracks clicks on category links' do
      event = wait_for_ahoy_js('COVID')

      expect(event.name).to eq("Category selected")
      expect(event.properties["category_name"]).to eq("COVID")
      expect(event.properties["from_homepage"]).to be_truthy
    end

    it 'tracks clicks on community links' do
      event = wait_for_ahoy_js('VA Immersive')

      expect(event.name).to eq("Category selected")
      expect(event.properties["category_name"]).to eq("VA Immersive")
      expect(event.properties["from_homepage"]).to be_truthy
    end

    it 'tracks clicks on "Browse all Innovations" link' do
      event = wait_for_ahoy_js('Browse all Innovations')

      expect(event.name).to eq("Dropdown Browse-all Link Clicked")
      expect(event.properties["type"]).to eq("innovation")
    end

    it 'tracks clicks on "Browse all Tags" link' do
      event = wait_for_ahoy_js('Browse all Tags')

      expect(event.name).to eq("Dropdown Browse-all Link Clicked")
      expect(event.properties["type"]).to eq("category")
    end

    it 'tracks clicks on "Browse all Community Innovations" link' do
      event = wait_for_ahoy_js('Browse all Community Innovations')

      expect(event.name).to eq("Dropdown Browse-all Link Clicked")
      expect(event.properties["type"]).to eq("community")
    end
  end

  def wait_for_ahoy_js(link_text)
    find('a', text: link_text).click
    # wait for js ahoy library to complete db call
      sleep 1
      ahoy_events = Ahoy::Event.all
      expect(ahoy_events.count).to eq(1)
      ahoy_events[0]
  end
end
