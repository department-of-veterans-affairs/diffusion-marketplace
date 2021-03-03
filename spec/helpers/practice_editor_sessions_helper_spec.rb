require 'rails_helper'

RSpec.describe PracticeEditorSessionsHelper, type: :helper do
  describe "#session_username" do
    context "when given a session with an admin user with first and last name" do
      it "returns the full name and (Site Admin)" do
        user = User.create!(email: 'test@va.gov', first_name: 'Ash', last_name: 'Ketchum', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        user.add_role(User::USER_ROLES[1].to_sym)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('Ash Ketchum (Site Admin)')
      end
    end

    context "when given a session with an admin user with first and no last name" do
      it "returns the first name and (Site Admin)" do
        user = User.create!(email: 'test@va.gov', first_name: 'Ash', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        user.add_role(User::USER_ROLES[1].to_sym)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('Ash (Site Admin)')
      end
    end

    context "when given a session with an admin user with last name and no first name" do
      it "returns the last name and (Site Admin)" do
        user = User.create!(email: 'test@va.gov', last_name: 'Ketchum', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        user.add_role(User::USER_ROLES[1].to_sym)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('Ketchum (Site Admin)')
      end
    end

    context "when given a session with an admin user with an email but no name" do
      it "returns the email and (Site Admin)" do
        user = User.create!(email: 'test@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        user.add_role(User::USER_ROLES[1].to_sym)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('test@va.gov (Site Admin)')
      end
    end

    context "when given a session with a user with first and last name" do
      it "returns name" do
        user = User.create!(email: 'test@va.gov', first_name: 'Ash', last_name: 'Ketchum', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('Ash Ketchum')
      end
    end

    context "when given a session with a user with only a first name and no last name" do
      it "returns the first name" do
        user = User.create!(email: 'test@va.gov', first_name: 'Ash', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('Ash')
      end
    end

    context "when given a session with a user with only a last name and no first name" do
      it "returns the last name" do
        user = User.create!(email: 'test@va.gov', last_name: 'Ketchum', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('Ketchum')
      end
    end

    context "when given a session with a user with no name" do
      it "returns email" do
        user = User.create!(email: 'test@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
        practice = Practice.create!(name: 'A public practice', slug: 'a-public-practice', approved: true, published: true, tagline: 'Test tagline', user: user)
        session = PracticeEditorSession.create(session_start_time: DateTime.now, practice: practice, user: user)
        expect(helper.session_username(session)).to eq('test@va.gov')
      end
    end
  end
end
