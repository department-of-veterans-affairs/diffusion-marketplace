class PracticeMailerWorker
  include Sidekiq::Worker

  def perform(email_type, *args)
    case email_type
    when "send_batch_email_to_editor"
      PracticeEditorMailer.send_batch_email_to_editor(*args).deliver_now
    when "send_batch_email_confirmation"
      PracticeEditorMailer.send_batch_email_confirmation(*args).deliver_now
    else
      raise ArgumentError, "Unknown email_type: #{email_type}"
    end
  end
end