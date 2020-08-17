require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
    before do
        @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        @practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline')
        @admin.add_role(User::USER_ROLES[0].to_sym)
        @departments = [
            Department.create!(name: 'Admissions', short_name: 'admissions'),
            Department.create!(name: 'Medical', short_name: 'none'),
        ]
    end

    fdescribe 'Departments Page' do
        before do
            login_as(@admin, :scope => :user, :run_callbacks => false)
            visit practice_departments_path(@practice)
            expect(page).to be_accessible.according_to :wcag2a, :section508
            @save_button = find('#practice-editor-save-button')
        end

        it 'should be there' do
            expect(page).to have_content('Departments')
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/resources")
            expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/timeline")
        end

        def check_department_fields
            find('label[for=practice_department_1]').click
            find('label[for=practice_department_2]').click
        end

        it 'should allow the user to add and remove departments' do
            check_department_fields
            @save_button.click
            expect(page).to have_checked_field('practice_department_1', visible: false)
            expect(page).to have_checked_field('practice_department_2', visible: false)
        end
    end
end