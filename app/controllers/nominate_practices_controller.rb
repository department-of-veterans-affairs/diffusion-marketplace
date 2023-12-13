class NominatePracticesController < ApplicationController
  include FormSpamsHelper
  def index
  end

  def email
    recaptcha_result = verify_recaptcha(action: 'email', minimum_score: 0.5)

    if recaptcha_result
      if params["phone"].present?
        log_spam_attempt "Nominate"
        redirect_to root_path
      else
        NominateAPracticeMailer.send_contact_email(options = { email: params[:email], subject: params[:subject], message: params[:message], message_url: request.url }, 'Nominate', 'nominate_a_practice_mailer/nominate_a_practice_email').deliver_now
        success = 'Message sent. The Diffusion Marketplace team will review your nomination.'
        flash[:success] = success
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, notice: flash[:notice] }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path }
      end
    end
  end
end

