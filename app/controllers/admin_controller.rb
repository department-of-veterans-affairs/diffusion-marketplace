class AdminController < ApplicationController
  def create_user
    password = generate_password
    user = User.create! user_params.merge(password: password, password_confirmation: password)
    AdminMailer.send_set_password(user_id: user.id, password: password).deliver
    flash[:success] = "Created user \"#{user.email}\""
    redirect_to controller: :users, action: :index
  end

  def user_params
    params.require(:user).permit(:email, :skip_va_validation, :confirmed_at)
  end

  def generate_password
    pw_strength = 0
    password = ''
    while pw_strength < 3
      pw_strength = 0
      password = Devise.friendly_token(12)

      pw_strength += 1 if /(.*?[A-Z])/.match?(password)
      pw_strength += 1 if /(.*?[a-z])/.match?(password)
      pw_strength += 1 if /(.*?[0-9])/.match?(password)
      pw_strength += 1 if /(.*?[#?!@$%^&*-])/.match?(password)
    end
    password
  end
end
