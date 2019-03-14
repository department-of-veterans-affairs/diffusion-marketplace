# frozen_string_literal: true

# Users controller, primarily for user admin management
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy re_enable, set_password]
  before_action :require_admin, only: %i[index update destroy re_enable]
  before_action :require_user_or_admin, only: :update
  before_action :final_admin, only: :update

  def index
    @users = User.all.order(:email).page(params[:page])
  end

  def update
    if params[:user][:role].present?
      if params[:user][:role] == 'user'
        @user.remove_all_roles('user')
        flash[:success] = "Basic \"user\" role assigned to \"#{@user.email}\""
      else
        @user.add_role(params[:user][:role])
        flash[:success] = "Added \"#{params[:user][:role]}\" role to user \"#{@user.email}\""
      end
    else
      @user.update_attributes user_params
    end
    redirect_to users_path
  end

  def destroy
    @user.update_attributes disabled: true
    flash[:success] = "Disabled user \"#{@user.email}\""
    redirect_to users_path
  end

  def re_enable
    @user.update_attributes disabled: false
    flash[:success] = "Re-enabled user \"#{user.email}\""
    redirect_to users_path
  end

  private

  def require_admin
    unless current_user.present? && current_user.has_role?(:admin)
      redirect_to :root
    end
  end

  # This is to cover any sort of User self-editting in the future (such as profile infomation)
  def require_user_or_admin
    unless current_user.present? && (current_user == @user || current_user.has_role?(:admin))
      redirect_to users_path
    end
  end

  def final_admin
    if User.with_role(:admin).count == 1 && @user == current_user.id && params[:user][:role].present? &&
       params[:user][:role] != 'admin'
      flash[:error] = 'There must always be at least 1 admin.'
      redirect_to users_path
    end
  end

  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :job_title, :first_name, :last_name, :phone_number, :visn, :skip_va_validation, :skip_password_validation)
  end
end
