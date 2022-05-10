class AboutController < ApplicationController
  include FormSpamControllerConcern
  def index
  end

  def email
    debugger
    if params["turnkey"].length > 0
      log_spam_attempt
      redirect_to root_path
      return
    end
    # TODO remove once we add captcha to form
    if helpers.is_user_a_guest?
      respond_to do |format|
        format.html { redirect_to root_path }
      end
    else
      #ContactUsMailer.send_contact_email(options = { email: params[:email], subject: params[:subject], message: params[:message] }, 'About', 'contact_us_mailer/contact_us_email').deliver_now
      success = 'You successfully sent a message to the Diffusion Marketplace team.'
      flash[:success] = success
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: flash[:notice] }
      end
    end
  end
end