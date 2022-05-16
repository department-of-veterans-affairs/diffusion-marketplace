class NominatePracticesController < ApplicationController

  def index
    # TODO remove once we add captcha to form
    redirect_to root_path if helpers.is_user_a_guest?
  end

  def email
    if params["phone"].to_s.length > 0
      log_spam_attempt "Nominate"
      redirect_to root_path
    else
      NominateAPracticeMailer.send_contact_email(options = { email: params[:email], subject: params[:subject], message: params[:message] }, 'Nominate', 'nominate_a_practice_mailer/nominate_a_practice_email').deliver_now
      success = 'Message sent. The Diffusion Marketplace team will review your nomination.'
      flash[:success] = success
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: flash[:notice] }
      end
    end
  end
end

