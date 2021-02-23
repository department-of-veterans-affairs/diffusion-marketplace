require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A practice with no resources', slug: 'test-practice', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), user: @admin)
    PracticeResource.create(practice: @practice, resource: 'core person 1', resource_type: 'core', media_type: 'resource', resource_type_label: 'people', position: 1 )
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Implementation page -- resource link:' do
    describe 'complete form, edit, and remove links' do
      def get_link_url(area, index)
        links = {
          '0': "https://www.google.com/#{area}",
          '1': "https://www.wikipedia.com/#{area}",
          '2': "https://www.youtube.com/#{area}"
        }
        links[index.to_s.to_sym]
      end

      def complete_add_link_test(area)
        # add links
        visit practice_implementation_path(@practice)

        within(:css, ".dm-#{area}-attachment-form") do
          expect(page).to have_no_content('Link (paste the full address)')
          expect(page).to have_no_content('Title')
          expect(page).to have_no_content('Description')
          click_link_form area
          expect(page).to have_content('Link (paste the full address)')
          expect(page).to have_content('Title')
          expect(page).to have_content('Description')
          add_resource
          # check that errors appear
          expect(page).to have_content('Please enter a valid url/link')
          first_url_field.set(get_link_url(area, 0))
          add_resource
          expect(page).to have_content('Please enter a link title')
          first_title_field.set("first new #{area} link")
          add_resource
          expect(page).to have_content('Please enter a link description')
          first_description_field.set("first new practice #{area} link")
          add_resource
          # check that errors are gone
          expect(find_all('.overview_error_msg').length).to eq 0
          # check that form cleared
          expect(first_url_field.value).to eq ''
          expect(first_title_field.value).to eq ''
          expect(first_description_field.value).to eq ''
          cancel_form area
          expect(page).to have_no_css("##{area}_resources_link_form")
          # add another link
          click_link_form area
          first_url_field.set(get_link_url(area, 1))
          first_title_field.set("second new #{area} link")
          first_description_field.set("second new practice #{area} link")
          add_resource
        end

        save_practice

        within(:css, "#display_#{area}_attachment_link") do
          expect(page).to have_content('Delete entry')
          expect(first_url_field.value).to eq get_link_url(area, 0)
          expect(first_title_field.value).to eq "first new #{area} link"
          expect(first_description_field.value).to eq "first new practice #{area} link"
          expect(second_url_field.value).to eq get_link_url(area, 1)
          expect(second_title_field.value).to eq "second new #{area} link"
          expect(second_description_field.value).to eq "second new practice #{area} link"
        end

        # check links appear in view
        visit practice_path(@practice)
        within(:css, '#dm-implementation-show-resources') do
          expect(page).to have_content("first new #{area} link")
          expect(page).to have_content("second new #{area} link")
          expect(page).to have_content("first new practice #{area} link")
          expect(page).to have_content("second new practice #{area} link")
          expect(page).to have_css("a[href='#{get_link_url(area, 0)}']")
          expect(page).to have_css("a[href='#{get_link_url(area, 1)}']")
        end

        # edit practice
        visit practice_implementation_path(@practice)
        within(:css, "#display_#{area}_attachment_link") do
          first_url_field.set(get_link_url(area, 2))
          first_title_field.set("first edited #{area} link")
          first_description_field.set("first edited practice #{area} link")
        end
        save_practice

        # check edited link appears in view
        visit practice_path(@practice)
        within(:css, '#dm-implementation-show-resources') do
          expect(page).to have_content("first edited #{area} link")
          expect(page).to have_content("second new #{area} link")
          expect(page).to have_content("first edited practice #{area} link")
          expect(page).to have_content("second new practice #{area} link")
          expect(page).to have_css("a[href='#{get_link_url(area, 1)}']")
          expect(page).to have_css("a[href='#{get_link_url(area, 2)}']")
          expect(page).to have_no_content("first new #{area} link")
          expect(page).to have_no_content("first new practice #{area} link")
          expect(page).to have_no_css("a[href='#{get_link_url(area, 0)}']")
        end

        # delete link
        visit practice_implementation_path(@practice)
        within(:css, "#display_#{area}_attachment_link") do
          delete_entry(0)
        end
        save_practice

        # check the links do not show up on view
        visit practice_path(@practice)
        within(:css, '#dm-implementation-show-resources') do
          expect(page).to have_no_content("first edited #{area} link")
          expect(page).to have_content("second new #{area} link")
          expect(page).to have_no_content("first edited practice #{area} link")
          expect(page).to have_content("second new practice #{area} link")
          expect(page).to have_css("a[href='#{get_link_url(area, 1)}']")
          expect(page).to have_no_css("a[href='#{get_link_url(area, 2)}']")
        end
      end

      it 'should save, edit, and delete links' do
        complete_add_link_test 'core'
        complete_add_link_test 'optional'
        complete_add_link_test 'support'
      end
    end
  end

  def first_url_field
    find_all('input[type="text"]').first
  end

  def first_title_field
    find_all('input[type="text"]')[1]
  end

  def first_description_field
    find_all('input[type="text"]')[2]
  end

  def second_url_field
    find_all('input[type="text"]')[3]
  end

  def second_title_field
    find_all('input[type="text"]')[4]
  end

  def second_description_field
    find_all('input[type="text"]')[5]
  end

  def delete_entry(index)
    find_all('.remove_nested_fields')[index].click
  end

  def click_link_form(area)
    find("label[for=#{area}_resource_attachment_link]").click
  end

  def add_resource
    find('.add-resource').click
  end

  def cancel_form(area)
    find("#cancel_#{area}_attachment_link").click
  end

  def save_practice
    find('#practice-editor-save-button').click
  end
end
