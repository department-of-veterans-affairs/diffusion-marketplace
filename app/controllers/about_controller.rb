class AboutController < ApplicationController
  def index
  end

  def email
    ContactUsMailer.send_contact_email(options = { email: params[:email], subject: params[:subject], message: params[:message] }, 'About', 'contact_us_mailer/contact_us_email').deliver_now
    success = 'You successfully sent a message to the Diffusion Marketplace team.'
    flash[:success] = success
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: flash[:notice] }
    end
  end
end