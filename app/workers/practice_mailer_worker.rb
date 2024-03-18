class PracticeMailerWorker
  include Sidekiq::Worker
   sidekiq_options retry: 5

  sidekiq_retries_exhausted do |msg, _|
    Rails.logger.error "Failed to deliver email, job arguments: #{msg['args'].inspect}"
  end

  def perform(email_type, *args)
    case email_type
    when "send_batch_email_to_editor"
      PracticeEditorMailer.send_batch_email_to_editor(*args).deliver_now
    when "send_batch_email_confirmation"
      PracticeEditorMailer.send_batch_email_confirmation(*args).deliver_now
    else
      raise ArgumentError, "Unknown email_type: #{email_type}"
    end
  rescue => e
    Rails.logger.error "Error sending email: #{e.message}"
    raise e
  end
end
