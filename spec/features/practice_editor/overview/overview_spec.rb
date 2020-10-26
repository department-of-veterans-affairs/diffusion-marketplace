require 'rails_helper'

describe 'Practice editor', type: :feature, js: true do
  before do
    @admin = User.create!(email: 'toshiro.hitsugaya@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @admin.add_role(User::USER_ROLES[0].to_sym)
    @practice = Practice.create!(name: 'A practice with no resources', slug: 'practice-no-resources', approved: true, published: true, date_initiated: Date.new(2011, 12, 31), overview_problem: 'existing problem', overview_solution: 'existing solution', overview_results: 'existing results')
    login_as(@admin, :scope => :user, :run_callbacks => false)
  end

  describe 'Overview page' do
    describe 'view and editor' do
      it 'should be accessible' do
        visit practice_path(@practice)
        expect(page).to be_accessible.according_to :wcag2a, :section508
        visit practice_overview_path(@practice)
        expect(page).to be_accessible.according_to :wcag2a, :section508
      end

      it 'should be able to change the problem, solution, results, statements' do
        visit practice_path(@practice)
        expect(page).to have_content('existing problem')
        expect(page).to have_content('existing solution')
        expect(page).to have_content('existing results')
        visit practice_overview_path(@practice)
        problem_statement.set('revised problem')
        solution_statement.set('revised solution')
        results_statement.set('revised results')
        find('#practice-editor-save-button').click
        visit practice_path(@practice)
        expect(page).to have_no_content('existing problem')
        expect(page).to have_no_content('existing solution')
        expect(page).to have_no_content('existing results')
        expect(page).to have_content('revised problem')
        expect(page).to have_content('revised solution')
        expect(page).to have_content('revised results')
      end
    end

    it 'should have the correct continue and back links' do
      visit practice_overview_path(@practice)
      within(:css, '.introduction') do
        expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/adoptions")
        expect(page).to have_link(href: "/practices/#{@practice.slug}/edit/implementation")
      end
    end
  end

  def problem_statement
    find_all('textarea').first
  end

  def solution_statement
    find_all('textarea')[1]
  end

  def results_statement
    find_all('textarea').last
  end

  def save_practice
    find('#practice-editor-save-button').click
  end
end
