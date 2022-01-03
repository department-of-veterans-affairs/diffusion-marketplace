require 'rails_helper'

describe 'Practice viewer - introduction', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @pr_min = Practice.create!(name: 'A public minimum practice', slug: 'a-public-min-practice', approved: true, published: true, tagline: 'Test tagline', summary: 'Test summary', date_initiated: Date.new(2011, 12, 31), initiating_facility_type: 'other', initiating_facility: 'foobar facility', user: @admin)
    img_path = "#{Rails.root}/spec/assets/acceptable_img.jpg"
    @pr_max = Practice.create!(name: 'A public maximum practice', short_name: 'LALA', slug: 'a-public-max-practice', approved: true, tagline: 'Test tagline', published: true, summary: 'Test summary', date_initiated: Date.new(2016, 8, 20), initiating_facility_type: 'facility', main_display_image: File.new(img_path), user: @admin, enabled: true)
    @practice_2 = Practice.create!(name: 'Another public maximum practice', short_name: 'BLA', slug: 'another-public-max-practice', approved: true, tagline: 'Test tagline', published: true, summary: 'Test summary', date_initiated: Date.new(2016, 8, 22), initiating_facility_type: 'facility', main_display_image: File.new(img_path), user: @admin, enabled: true)

    visn_6 = Visn.create!(id: 5, name: "VA Mid-Atlantic Health Care Network", number: 6)
    visn_9 = Visn.create!(id: 8, name: "VA MidSouth Healthcare Network", number: 9)
    visn_21 = Visn.create!(id: 16, name: "Sierra Pacific Network", number: 21)
    visn_23 = Visn.create!(id: 18, name: "VA Midwest Health Care Network", number: 23)

    facility_1 = VaFacility.create!(
      visn: visn_21,
      station_number: "640A0",
      official_station_name: "Palo Alto VA Medical Center-Menlo Park",
      common_name: "Palo Alto-Menlo Park",
      street_address_state: "CA",
      station_phone_number: "207-623-2123 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    facility_2 = VaFacility.create!(
      visn: visn_9,
      station_number: "603",
      official_station_name: "Robley Rex Department of Veterans Affairs Medical Center",
      common_name: "Louisville",
      street_address_state: "KY",
      station_phone_number: "123-456-7891 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    facility_3 = VaFacility.create!(
      visn: visn_23,
      station_number: "636",
      official_station_name: "Omaha VA Medical Center",
      common_name: "Omaha-Nebraska",
      street_address_state: "NE",
      station_phone_number: "987-654-3210 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    facility_4 = VaFacility.create!(
      visn: visn_6,
      station_number: "590",
      official_station_name: "Hampton VA Medical Center",
      common_name: "Hampton",
      street_address_state: "VA",
      station_phone_number: "243-5462-6421 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )
    facility_5 = VaFacility.create!(
      visn: visn_6,
      station_number: "652",
      official_station_name: "Hunter Holmes McGuire Hospital",
      common_name: "Richmond-Virginia",
      street_address_state: "VA",
      station_phone_number: "757-432-1543 x",
      fy17_parent_station_complexity_level: "1c-High Complexity"
    )

    PracticeOriginFacility.create!(practice: @pr_max, facility_type: 0, va_facility: facility_1)
    PracticeOriginFacility.create!(practice: @pr_max, facility_type: 0, va_facility: facility_2)
    PracticeOriginFacility.create!(practice: @pr_max, facility_type: 0, va_facility: facility_3)
    PracticeOriginFacility.create!(practice: @pr_max, facility_type: 0, va_facility: facility_4)
    PracticeOriginFacility.create!(practice: @pr_max, facility_type: 0, va_facility: facility_5)
    PracticeAward.create!(practice: @pr_max, name: 'QUERI Veterans Choice Act Award', created_at: Time.now)
    PracticeAward.create!(practice: @pr_max, name: 'Diffusion of Excellence Promising Practice', created_at: Time.now)
    PracticeAward.create!(practice: @pr_max, name: 'VHA Shark Tank Winner', created_at: Time.now)
    PracticeAward.create!(practice: @pr_max, name: 'Other', created_at: Time.now)
    PracticeAward.create!(practice: @pr_max, name: 'An amazing award that the whole team is proud of', created_at: Time.now)
    PracticeAward.create!(practice: @pr_max, name: 'Another great award that this innovation can show off', created_at: Time.now)
    @pr_partner_1 = PracticePartner.create!(name: 'Diffusion of Excellence', short_name: '', description: 'The Diffusion of Excellence Initiative helps to identify and disseminate clinical and administrative best innovations through a learning environment that empowers its top performers to apply their innovative ideas throughout the system — further establishing VA as a leader in health care, while promoting positive outcomes for Veterans.', icon: 'fas fa-heart', color: '#E4A002')
    @pr_partner_2 = PracticePartner.create!(name: 'Office of Rural Health', short_name: 'ORH', description: 'Congress established the Veterans Health Administration Office of Rural Health in 2006 to conduct, coordinate, promote and disseminate research on issues that affect the nearly five million Veterans who reside in rural communities. Working through its three Veterans Rural Health Resource Centers, as well as partners from academia, state and local governments, private industry, and non-profit organizations, ORH strives to break down the barriers separating rural Veterans from quality care.', icon: 'fas fa-mountain', color: '#1CC2AE')
    PracticePartnerPractice.create!(practice: @pr_max, practice_partner: @pr_partner_1, created_at: Time.now)
    PracticePartnerPractice.create!(practice: @pr_max, practice_partner: @pr_partner_2, created_at: Time.now)
    @parent_cat = Category.create!(name: 'First Parent Category', is_other: false)
    @cat_1 = Category.create!(name: 'COVID', parent_category: @parent_cat)
    @cat_2 = Category.create!(name: 'Environmental Services', parent_category: @parent_cat)
    @cat_3 = Category.create!(name: 'Follow-up Care', parent_category: @parent_cat)
    @cat_4 = Category.create!(name: 'Other', parent_category: @parent_cat)
    CategoryPractice.create!(practice: @pr_max, category: @cat_1, created_at: Time.now)
    CategoryPractice.create!(practice: @pr_max, category: @cat_2, created_at: Time.now)
    CategoryPractice.create!(practice: @pr_max, category: @cat_3, created_at: Time.now)
    CategoryPractice.create!(practice: @pr_max, category: @cat_4, created_at: Time.now)
    CategoryPractice.create!(practice: @practice_2, category: @cat_1, created_at: Time.now)

    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'action buttons' do
    before do
      visit practice_path(@pr_min)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should exist' do
      expect(page).to have_content('Bookmark')
      expect(page).to have_content('Share')
      expect(page).to have_content('Print')
    end

    it 'should be interactive' do
      find('.dm-favorite-practice-link').click
      expect(page).to have_content('Bookmarked')
      find('.dm-favorite-practice-link').click
      expect(page).to have_content('Bookmark')
      expect(page).to have_selector(:css, "a[href='mailto:?subject=VA%20Diffusion%20Marketplace%20-%20A%20public%20minimum%20practice%20summary&body=Check out this practice, A public minimum practice: Test tagline, on the VA Diffusion Marketplace: %0D%0A%0D%0A#{ENV.fetch('HOSTNAME')}/innovations/a-public-min-practice%0D%0A%0D%0AAbout A public minimum practice: %0D%0A%0D%0A%0D%0A%0D%0ATest summary%0D%0A%0D%0A']")
      # TODO: How to test print?
    end
  end

  describe 'see more buttons' do
    before do
      visit practice_path(@pr_max)
      expect(page).to be_accessible.according_to :wcag2a, :section508
    end

    it 'should exist' do
      expect(page).to have_content('See more')
    end

    context 'origin section' do
      it 'should expand content on click' do
        expect(page).to have_content('Palo Alto VA Medical Center-Menlo Park (Palo Alto-Menlo Park), Robley Rex Department of Veterans Affairs Medical Center (Louisville), Omaha VA Medical Center (Omaha-Nebraska), Hampton...')
        expect(page).to have_content('See more')
        click_link('See more')
        expect(page).to have_content('Palo Alto VA Medical Center-Menlo Park (Palo Alto-Menlo Park), Robley Rex Department of Veterans Affairs Medical Center (Louisville), Omaha VA Medical Center (Omaha-Nebraska), Hampton VA Medical Center, Hunter Holmes McGuire Hospital (Richmond-Virginia)')
        expect(page).to have_content('See less')
        click_link('See less')
        expect(page).to have_content('Palo Alto VA Medical Center-Menlo Park (Palo Alto-Menlo Park), Robley Rex Department of Veterans Affairs Medical Center (Louisville), Omaha VA Medical Center (Omaha-Nebraska), Hampton...')
        expect(page).to have_content('See more')
      end

      it 'should provide a link for each origin VA facility or VISN that directs the user to the show page of that facility/VISN' do
        new_window = window_opened_by { click_link('Palo Alto VA Medical Center-Menlo Park (Palo Alto-Menlo Park)') }
        within_window new_window do
          expect(page).to have_content('Palo Alto VA Medical Center-Menlo Park')
          expect(page).to have_content('This facility has created')
          expect(page).to have_content('Main number:')
        end

        visit practice_introduction_path(@pr_max)
        find('#initiating_facility_type_visn').sibling('label').click
        select('VISN-6', :from => 'editor_visn_select')
        find('#practice-editor-save-button').click
        visit practice_path(@pr_max)

        new_window = window_opened_by { click_link 'VISN-6' }
        within_window new_window do
          expect(page).to have_content('VISN 6: VA Mid-Atlantic Health Care Network')
          expect(page).to have_content('This VISN has 2 facilities')
        end
      end
    end

    context 'awards and recognition section' do
      it 'should expand content on click' do
        expect(page).to have_content('QUERI Veterans Choice Act Award, Diffusion of Excellence Promising Practice, VHA Shark Tank Winner, An amazing award that the whole team is proud of, Another great award that this ...')
        expect(page).to have_content('See more')
        find('#seeMore_award').click
        expect(page).to have_content('QUERI Veterans Choice Act Award, Diffusion of Excellence Promising Practice, VHA Shark Tank Winner, An amazing award that the whole team is proud of, Another great award that this innovation can show off')
        expect(page).to have_content('See less')
        find('#seeMore_award').click
        expect(page).to have_content('QUERI Veterans Choice Act Award, Diffusion of Excellence Promising Practice, VHA Shark Tank Winner, An amazing award that the whole team is proud of, Another great award that this ...')
        expect(page).to have_content('See more')
      end
    end
  end

  describe 'partners section' do
    before do
      visit practice_path(@pr_max)
    end

    it 'should display the content correctly' do
      expect(page).to have_content(@pr_partner_1.name)
      expect(page).to have_content(@pr_partner_2.name)
      expect(page).to have_link(href: practice_partner_path(@pr_partner_1))
      expect(page).to have_link(href: practice_partner_path(@pr_partner_2))
    end
  end

  describe 'categories section' do
    before do
      visit practice_path(@pr_max)
    end

    it 'should display the content correctly' do
      expect(page).to have_link('COVID')
      expect(page).to have_link('Environmental Services')
      expect(page).to have_link('Follow-up Care')
      expect(page).to_not have_link('Other')
    end

    it 'should take the user to the search page with results that match the category that was clicked on' do
      all('.usa-tag').first.click
      expect(page).to have_current_path('/search?filter_by=COVID')
      expect(page).to have_selector('#search-page', visible: true)
      expect(page).to have_content('2 results')
      expect(page).to have_content('A public maximum practice')
      expect(page).to have_content('Another public maximum practice')
    end
  end

  describe 'maturity level indicators' do
    before do
      # set maturity level
      @pr_max.update_attributes(maturity_level: 'emerging')
      visit practice_path(@pr_max)
    end

    it 'should display the content correctly' do
      expect(page).to have_content('This innovation is emerging and worth watching as it is being assessed in early implementations.')
      expect(page).to have_link('See more emerging innovations.')
    end

    it 'should take the user to the search results page when the See more practices link is clicked' do
      click_link('See more emerging innovations')
      expect(page).to have_selector('#search-page', visible: true)
      expect(page).to have_content('1 result')
      expect(page).to have_content('A public maximum practice')
    end
  end

  describe 'practice page with minimum content' do
    before do
      visit practice_path(@pr_min)
    end

    it 'should display the content correctly' do
      expect(page).to have_content(@pr_min.name)
      expect(page).to have_current_path("/innovations/#{@pr_min.slug}")
      expect(page).to have_content('Last updated') # TODO: How to test timeago?
      expect(page).to have_content(@pr_min.summary)
      expect(page).to have_content("ORIGIN: December 2011, #{@pr_min.initiating_facility}")
      expect(page).to have_no_content('AWARDS AND RECOGNITION')
      expect(page).to have_no_content('PARTNERS')
      expect(page).to have_no_content('UPDATES')
    end
  end

  describe 'practice page with maximum content' do
    before do
      visit practice_path(@pr_max)
    end

    it 'should display the content correctly' do
      expect(page).to have_content("#{@pr_max.name} (#{@pr_max.short_name})")
      expect(page).to have_current_path("/innovations/#{@pr_max.slug}")
      expect(page).to have_content('Last updated') # TODO: How to test timeago?
      expect(page).to have_content(@pr_max.summary)
      expect(page).to have_content("ORIGIN: August 2016")
      expect(page).to have_content('AWARDS AND RECOGNITION')
      expect(page).to have_content('PARTNERS')
      expect(page).to have_no_content('UPDATES')
    end
  end
end
