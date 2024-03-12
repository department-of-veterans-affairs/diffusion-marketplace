require 'rails_helper'

RSpec.describe PracticeMailerWorker, type: :worker do
  let(:subject_text) { 'Important Update' }
  let(:message_text) { 'Please review the latest changes.' }
  let(:user_email) { 'test@example.com' }
  let(:practice_names) { ['Innovation A'] }
  let(:filters) { {'not_updated_since' => 3.days.ago.to_date.to_s} }
  let(:practices_data) {
    {
      'user_info' => {'user_name' => 'Test User', 'email' => user_email},
      'practices' => [{'practice_name' => 'Innovation A', 'show_url' => 'http://test.com/practices/1', 'practice_id' => 1, 'last_updated_on' => '2023-03-10'}]
    }
  }
  let(:mailer_args) {
    {
      'subject' => subject_text,
      'message' => message_text,
      'practices_data' => practices_data,
      'filters' => filters,
      'sender_email_address' => 'admin@example.com'
    }
  }

  describe 'perform' do
    context 'when email_type is send_batch_email_to_editor' do
      it 'calls PracticeEditorMailer.send_batch_email_to_editor with correct arguments' do
        allow(PracticeEditorMailer).to receive(:send_batch_email_to_editor).and_call_original
        described_class.new.perform('send_batch_email_to_editor', mailer_args)

        expect(PracticeEditorMailer).to have_received(:send_batch_email_to_editor).with(mailer_args)
      end
    end

    context 'when email_type is send_batch_email_confirmation' do
      it 'calls PracticeEditorMailer.send_batch_email_confirmation with correct arguments' do
        allow(PracticeEditorMailer).to receive(:send_batch_email_confirmation).and_call_original
        described_class.new.perform('send_batch_email_confirmation', mailer_args)

        expect(PracticeEditorMailer).to have_received(:send_batch_email_confirmation).with(mailer_args)
      end
    end

    context 'with an unknown email_type' do
      it 'raises an ArgumentError' do
        expect { described_class.new.perform('unknown_email_type', mailer_args) }.to raise_error(ArgumentError, 'Unknown email_type: unknown_email_type')
      end
    end
  end
end