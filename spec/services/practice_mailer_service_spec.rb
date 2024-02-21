require 'rails_helper'

RSpec.describe PracticeMailerService do
  describe '.call' do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:subject_text) { 'Important Update' }
    let(:message_text) { 'Please review the latest changes.' }

    let!(:practice) { create(:practice, user: admin, published: true) }
    let!(:practice_a) { create(:practice, name: "Innovation A", user: user, published: true, updated_at: 2.days.ago, last_email_date: 3.days.ago) }
    let!(:practice_b) { create(:practice, name: "Innovation B", user: other_user, published: true, updated_at: 4.days.ago, last_email_date: nil) }
    let!(:unpublished_practice) { create(:practice, name: "Innovation C", user: user, published: false, updated_at: 1.day.ago) }

    before do
      create(:practice_editor, user: other_user, practice: practice_a)
      create(:practice_editor, user: user, practice: practice_b)
      create(:practice_editor, user: admin, practice: unpublished_practice)

      ActionMailer::Base.deliveries.clear
    end

    it 'sends an email to the editor with exact email and practice info' do
      filters = {}

      PracticeMailerService.call(
        subject: subject_text,
        message: message_text,
        current_user: admin,
        filters: filters
      )
      emails = ActionMailer::Base.deliveries
      expect(emails.count).to eq(3)

      user_email = emails.find { |e| e.to.include?(user.email) }
      expect(user_email.subject).to eq(subject_text)
      expect(user_email.to).to include(user.email)
      expect(user_email.body.encoded).to include(practice_a.name)
      expect(user_email.body.encoded).to include(practice_b.name)
      expect(user_email.body.encoded).not_to include(practice.name)
      expect(user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
      expect(user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

      other_user_email = emails.find { |e| e.to.include?(other_user.email) }
      expect(other_user_email.subject).to eq(subject_text)
      expect(other_user_email.to).to include(other_user.email)
      expect(other_user_email.body.encoded).to include(practice_a.name)
      expect(other_user_email.body.encoded).to include(practice_b.name)
      expect(other_user_email.body.encoded).not_to include(practice.name)
      expect(other_user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
      expect(other_user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

      admin_email = emails.find { |e| e.to.include?(admin.email) }
      expect(admin_email.subject).to eq(subject_text)
      expect(admin_email.to).to include(admin.email)
      expect(admin_email.body.encoded).to include(practice.name)
      expect(admin_email.body.encoded).not_to include(practice_a.name)
      expect(admin_email.body.encoded).not_to include(practice_b.name)
      expect(admin_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice, Rails.application.config.action_mailer.default_url_options))
    end

    context 'when applying specific filters' do
      let(:filters) { { "name_cont" => "Innovation A" } }

      it 'sends emails based on attribute filters correctly' do
        PracticeMailerService.call(
          subject: subject_text,
          message: message_text,
          current_user: admin,
          filters: filters
        )

        emails = ActionMailer::Base.deliveries
        expect(emails.count).to eq(2)

        user_email = emails.find { |e| e.to.include?(user.email) }
        expect(user_email.subject).to eq(subject_text)
        expect(user_email.to).to include(user.email)
        expect(user_email.body.encoded).to include(practice_a.name)
        expect(user_email.body.encoded).not_to include(practice_b.name)
        expect(user_email.body.encoded).not_to include(practice.name)
        expect(user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
        expect(user_email.body.encoded).not_to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

        other_user_email = emails.find { |e| e.to.include?(other_user.email) }
        expect(other_user_email.subject).to eq(subject_text)
        expect(other_user_email.to).to include(other_user.email)
        expect(other_user_email.body.encoded).to include(practice_a.name)
        expect(other_user_email.body.encoded).not_to include(practice_b.name)
        expect(other_user_email.body.encoded).not_to include(practice.name)
        expect(other_user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
        expect(other_user_email.body.encoded).not_to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))
      end
    end

    context 'when applying specific scope filters' do
      let(:filters) { { "not_updated_since" => 3.days.ago.to_date.to_s, "not_emailed_since" => 2.days.ago.to_date.to_s } }

      it 'sends emails based on scope filters correctly' do
        PracticeMailerService.call(
          subject: subject_text,
          message: message_text,
          current_user: admin,
          filters: filters
        )

        emails = ActionMailer::Base.deliveries
        expect(emails.count).to eq(2)

        user_email = emails.find { |e| e.to.include?(user.email) }
        expect(user_email.subject).to eq(subject_text)
        expect(user_email.to).to include(user.email)
        expect(user_email.body.encoded).not_to include(practice_a.name)
        expect(user_email.body.encoded).to include(practice_b.name)
        expect(user_email.body.encoded).not_to include(practice.name)
        expect(user_email.body.encoded).not_to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
        expect(user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

        other_user_email = emails.find { |e| e.to.include?(other_user.email) }
        expect(other_user_email.subject).to eq(subject_text)
        expect(other_user_email.to).to include(other_user.email)
        expect(other_user_email.body.encoded).not_to include(practice_a.name)
        expect(other_user_email.body.encoded).to include(practice_b.name)
        expect(other_user_email.body.encoded).not_to include(practice.name)
        expect(other_user_email.body.encoded).not_to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
        expect(other_user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))
      end
    end

    context 'when applying filters that match no practices' do
      let(:filters) { { "name_cont" => "Nonexistent Innovation" } }

      it 'does not send any emails when no practices match the filters' do
        PracticeMailerService.call(
          subject: subject_text,
          message: message_text,
          current_user: admin,
          filters: filters
        )

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end
