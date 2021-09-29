class NominatePracticesController < ApplicationController
  def index
  end

  def email
    NominateAPracticeMailer.send_contact_email(options = { email: params[:email], subject: params[:subject], message: params[:message] }, 'Nominate', 'nominate_a_practice_mailer/nominate_a_practice_email').deliver_now
    success = 'Message sent. The Diffusion Marketplace team will review your nomination.'
    flash[:success] = success
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: flash[:notice] }
    end
  end
end

