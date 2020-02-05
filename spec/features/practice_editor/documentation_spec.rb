require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
    end

    describe 'Documentation Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_documentation_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
            @doc_path = File.join(Rails.root, '/spec/assets/dummy.pdf')
            @doc_title = 'Test title'
            @pub_title = 'Test link title'
            @pub_link = 'www.awesomelink.com'
        end

        it 'should be there' do
            expect(page).to have_content('Documentation')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/impact")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/resources")
        end

        it 'should require the user to fill out both fields for publications and additional documents if at least one field is filled out for either' do
            find('.additional-document-title-input').set(@doc_title)
            @save_button.click
            add_doc_file_message = page.find('.hidden-upload').native.attribute('validationMessage')
            expect(add_doc_file_message).to eq('Please select a file.')
            find('.additional-document-title-input').set(nil)
            attach_file('Upload file', @doc_path)
            @save_button.click
            add_doc_title_message = page.find('.additional-document-title-input').native.attribute('validationMessage')
            expect(add_doc_title_message).to eq('Please fill out this field.')
        end

        def fill_in_doc_fields
            find('.additional-document-title-input').set(@doc_title)
            attach_file('Upload file', @doc_path)
        end

        def fill_in_pub_fields
            find('.publication-title-input').set(@pub_title)
            find('.publication-link-input').set(@pub_link)
        end

        it 'should allow the user to add a file upload and a link attachment' do
            fill_in_doc_fields
            fill_in_pub_fields
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('practice[additional_documents_attributes][0][title]', with: @doc_title)
            expect(page).to have_content('dummy.pdf')
            expect(page).to have_field('practice[publications_attributes][0][title]', with: @pub_title)
            expect(page).to have_field('practice[publications_attributes][0][link]', with: @pub_link)
        end

        it 'should allow the user to add multiple file uploads and link attachments' do
            fill_in_doc_fields
            find('.add-additional-document-link').click

            all('.hidden-documentation-field').last.attach_file(@doc_path)
            all('.additional-document-title-input').last.set('Test title 2')

            fill_in_pub_fields
            find('.add-publication-link').click

            all('.publication-title-input').last.set('Test link title 2')
            all('.publication-link-input').last.set('www.awesomelink2.com')
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(page).to have_field('practice[additional_documents_attributes][0][title]', with: @doc_title)
            expect(page).to have_field('practice[additional_documents_attributes][1][title]', with: 'Test title 2')
            expect(page).to have_content('dummy.pdf', count: 2)
            expect(page).to have_field('practice[publications_attributes][0][title]', with: @pub_title)
            expect(page).to have_field('practice[publications_attributes][0][link]', with: @pub_link)
            expect(page).to have_field('practice[publications_attributes][1][title]', with: 'Test link title 2')
            expect(page).to have_field('practice[publications_attributes][1][link]', with: 'www.awesomelink2.com')
        end

        it 'should allow the user to delete additional documents and video files' do
            fill_in_doc_fields
            fill_in_pub_fields
            @save_button.click

            all('.documentation-trash').first.click
            all('.documentation-trash').last.click
            @save_button.click

            expect(page).to have_content('Practice was successfully updated')
            expect(all('.additional-document-title-input').first.text).to be_blank
            expect(page).to_not have_content('dummy.pdf')
            expect(all('.publication-title-input').first.text).to be_blank
            expect(page).to have_field('Link:', with: nil)
        end
    end
end