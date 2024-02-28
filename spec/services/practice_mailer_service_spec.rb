require 'rails_helper'

RSpec.describe PracticeMailerService do
  describe '.call' do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    let(:subject_text) { 'Important Update' }
    let(:message_text) { 'Please review the latest changes.' }

    let!(:practice) { create(:practice, user: user3, published: true) }
    let!(:practice_a) { create(:practice, name: "Innovation A", user: user, published: true, updated_at: 2.days.ago, last_email_date: 3.days.ago) }
    let!(:practice_b) { create(:practice, name: "Innovation B", user: user2, published: true, updated_at: 4.days.ago, last_email_date: nil) }
    let!(:unpublished_practice) { create(:practice, name: "Innovation C", user: user, published: false, updated_at: 1.day.ago) }

    before do
      create(:practice_editor, user: user2, practice: practice_a)
      create(:practice_editor, user: user, practice: practice_b)
      create(:practice_editor, user: user3, practice: unpublished_practice)

      ActionMailer::Base.deliveries.clear
    end

    it 'sends an email to all owners and editors of published practices' do
      filters = {}

      described_class.call(
        subject: subject_text,
        message: message_text,
        current_user: admin,
        filters: filters
      )
      emails = ActionMailer::Base.deliveries
      expect(emails.count).to eq(4)

      user_email = emails.find { |e| e.to.include?(user.email) }
      expect(user_email.subject).to eq(subject_text)
      expect(user_email.to).to include(user.email)
      expect(user_email.body.encoded).to include(practice_a.name)
      expect(user_email.body.encoded).to include(practice_b.name)
      expect(user_email.body.encoded).not_to include(practice.name)
      expect(user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
      expect(user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

      user2_email = emails.find { |e| e.to.include?(user2.email) }
      expect(user2_email.subject).to eq(subject_text)
      expect(user2_email.to).to include(user2.email)
      expect(user2_email.body.encoded).to include(practice_a.name)
      expect(user2_email.body.encoded).to include(practice_b.name)
      expect(user2_email.body.encoded).not_to include(practice.name)
      expect(user2_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
      expect(user2_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

      user3_email = emails.find { |e| e.to.include?(user3.email) }
      expect(user3_email.subject).to eq(subject_text)
      expect(user3_email.to).to include(user3.email)
      expect(user3_email.body.encoded).to include(practice.name)
      expect(user3_email.body.encoded).not_to include(practice_a.name)
      expect(user3_email.body.encoded).not_to include(practice_b.name)
      expect(user3_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice, Rails.application.config.action_mailer.default_url_options))

      admin_email = emails.find { |e| e.to.include?(admin.email) }
      expect(admin_email.subject).to eq('Confirmation: Diffusion Marketplace Innovation Batch Emails Sent')
      expect(admin_email.body.encoded).not_to include(practice.name)
      expect(admin_email.body.encoded).not_to include(practice_a.name)
      expect(admin_email.body.encoded).not_to include(practice_b.name)
      expect(admin_email.body.encoded).to include("The above message has been sent to the editors and owners of all published Innovations")

      super_admin_email = emails.find { |e| e.to.include?("marketplace@va.gov") }
      expect(super_admin_email.subject).to eq('Confirmation: Diffusion Marketplace Innovation Batch Emails Sent')
      expect(super_admin_email.body.encoded).not_to include(practice.name)
      expect(super_admin_email.body.encoded).not_to include(practice_a.name)
      expect(super_admin_email.body.encoded).not_to include(practice_b.name)
      expect(super_admin_email.body.encoded).to include("The above message has been sent to the editors and owners of all published Innovations")
    end

    context 'when applying specific scope filters' do
      let(:filters) { { "not_updated_since" => 3.days.ago.to_date.to_s, "not_emailed_since" => 2.days.ago.to_date.to_s } }

      it 'sends emails based on scope filters correctly' do
        described_class.call(
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
        expect(user_email.body.encoded).not_to include(practice_a.name)
        expect(user_email.body.encoded).to include(practice_b.name)
        expect(user_email.body.encoded).not_to include(practice.name)
        expect(user_email.body.encoded).not_to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
        expect(user_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

        user2_email = emails.find { |e| e.to.include?(user2.email) }
        expect(user2_email.subject).to eq(subject_text)
        expect(user2_email.to).to include(user2.email)
        expect(user2_email.body.encoded).not_to include(practice_a.name)
        expect(user2_email.body.encoded).to include(practice_b.name)
        expect(user2_email.body.encoded).not_to include(practice.name)
        expect(user2_email.body.encoded).not_to include(Rails.application.routes.url_helpers.practice_url(practice_a, Rails.application.config.action_mailer.default_url_options))
        expect(user2_email.body.encoded).to include(Rails.application.routes.url_helpers.practice_url(practice_b, Rails.application.config.action_mailer.default_url_options))

        admin_email = emails.find { |e| e.to.include?(admin.email) }
        expect(admin_email.subject).to eq('Confirmation: Diffusion Marketplace Innovation Batch Emails Sent')
        expect(admin_email.body.encoded).to include("The above message has been sent to the editors and owners of the following Innovations:")
        expect(admin_email.body.encoded).to include(practice_b.name)
        expect(admin_email.body.encoded).not_to include(practice.name)
        expect(admin_email.body.encoded).not_to include(practice_a.name)
        expect(admin_email.body.encoded).to include("not_updated_since: #{3.days.ago.to_date}")
      end
    end

    context 'when applying filters that match no practices' do
      let(:filters) { { "not_updated_since" => 5.days.ago.to_date.to_s } }
      it 'does not send any emails when no practices match the filters' do
        PracticeMailerService.call(
          subject: subject_text,
          message: message_text,
          current_user: admin,
          filters: filters
        )
        emails = ActionMailer::Base.deliveries
        expect(emails.count).to eq(1)
        admin_email = emails.find { |e| e.to.include?(admin.email) }
        expect(admin_email.subject).to eq('Failure: Diffusion Marketplace Innovation Batch Emails Not Sent')
        expect(admin_email.body.encoded).to include("You attempted to send the above message to filtered Innovation owners and editors but the applied filters returned no Innovation results.")
        expect(admin_email.body.encoded).not_to include(practice_b.name)
        expect(admin_email.body.encoded).not_to include(practice.name)
        expect(admin_email.body.encoded).not_to include(practice_a.name)
        expect(admin_email.body.encoded).to include("not_updated_since: #{5.days.ago.to_date}")
      end
    end
  end
end
