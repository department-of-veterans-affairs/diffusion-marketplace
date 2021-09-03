class AboutController < ApplicationController
  def index
  end

  def email
    ContactUsMailer.contact_us_email(email: params[:email], subject: params[:subject]).deliver_now
    success = 'You successfully sent a message to the Diffusion Marketplace team.'
    flash[:success] = success
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: flash[:notice] }
    end
  end
end