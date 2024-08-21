class NominatePracticesController < ApplicationController
  include FormSpamsHelper
  def index
  end

  def email
    if current_user.present?
      handle_nomination
    else
      begin
        recaptcha_result = verify_recaptcha(action: 'email', minimum_score: 0.3)

        if recaptcha_result
          handle_nomination
        else
          log_recaptcha_failure(recaptcha_reply, params[:email])
          flash.clear
          flash[:error] = 'reCAPTCHA verification failed, please try again.'
          redirect_with_flash
        end
      rescue StandardError => e
        log_recaptcha_error(e, params[:email])
        flash.clear
        flash[:error] = 'reCAPTCHA verification failed due to an error. Please try again.'
        redirect_with_flash
      end
    end
  end

  private

  def handle_nomination
    if params["phone"].present?
      log_spam_attempt "Nominate"
      redirect_to root_path
    else
      NominateAPracticeMailer.send_contact_email(
        options = {
          email: params[:email],
          subject: params[:subject],
          message: params[:message],
          message_url: request.url
        },
        'Nominate', 'nominate_a_practice_mailer/nominate_a_practice_email'
      ).deliver_now

      flash[:success] = 'Message sent. The Diffusion Marketplace team will review your nomination.'
      redirect_with_flash
    end
  end

  def log_recaptcha_failure(score, email)
    Rails.logger.info(
      "Nominate innovation form reCAPTCHA score below threshold: reply: #{recaptcha_reply}, submitted_email: #{email}"
    )
  end

  def log_recaptcha_error(error, email)
    Rails.logger.error("reCAPTCHA verification failed in NominatePracticesController#email for email: #{email} - Error: #{error.message}")
  end

  def redirect_with_flash
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path}
    end
  end
end
