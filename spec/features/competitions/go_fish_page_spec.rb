require 'rails_helper'

describe 'Go Fish landing page', type: :feature do
  before do
    @user = User.create!(email: 'shusuke.amagai@soulsociety.com', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
    @practice = Practice.create!(name: 'A public practice', approved: true, published: true, tagline: 'Test tagline')
    @practice2 = Practice.create!(name: 'A second public practice', approved: true, published: true, tagline: 'Test tagline')
    @practice3 = Practice.create!(name: 'A third public practice', approved: true, published: true, tagline: 'Test tagline')
    @practice_partner = PracticePartner.create!(name: 'VHA Innovators Network')
    @practice_partner_practice = PracticePartnerPractice.create!(practice_partner_id: @practice_partner.id, practice_id: @practice.id)
    @practice_partner_practice = PracticePartnerPractice.create!(practice_partner_id: @practice_partner.id, practice_id: @practice2.id)
    @practice_partner_practice = PracticePartnerPractice.create!(practice_partner_id: @practice_partner.id, practice_id: @practice3.id)
  end

  it 'should be there' do
    visit '/'
    click_on('Bulletin')
    click_on('GoFish!')
    expect(page).to be_accessible.according_to :wcag2a, :section508
    expect(page).to have_content('Go Fish!')
    expect(page).to have_content('The VHA Innovators Network (iNET) consists of 33 VHA facilities throughout the country and commands the power of hundreds of frontline employee innovators.')
    expect(page).to have_content('If you have an innovative program, process, or just an idea; review the Go Fish! FAQs to see if Go Fish! is right for you.')
  end

  def visit_go_fish_page
    visit '/competitions/go-fish'
  end

  it 'should display the current iNET practices' do
    visit_go_fish_page
    expect(page).to have_content('iNET Practices')
    expect(page).to have_content(@practice.name)
    expect(page).to have_content(@practice2.name)
    expect(page).to have_content(@practice3.name)
  end

  it 'should allow the user to visit a practice page when they click on a practice card title' do
    visit_go_fish_page
    click_on(@practice.name)
    expect(page).to have_content('A public practice')
  end
end