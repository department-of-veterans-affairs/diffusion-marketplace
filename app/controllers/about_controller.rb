class AboutController < ApplicationController
  include FormSpamsHelper
  def index
  end

  def email
    recaptcha_result = verify_recaptcha(action: 'email', minimum_score: 0.5) # Adjust the minimum_score as needed

    if recaptcha_result
      if params["phone"].present?
        log_spam_attempt "About"
        redirect_to root_path
      else
        ContactUsMailer.send_contact_email(options = { email: params[:email], subject: params[:subject], message: params[:message] }, 'About', 'contact_us_mailer/contact_us_email').deliver_now
        success = 'You successfully sent a message to the Diffusion Marketplace team.'
        flash[:success] = success
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, notice: flash[:notice] }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to '/' }
      end
    end
  end
end
