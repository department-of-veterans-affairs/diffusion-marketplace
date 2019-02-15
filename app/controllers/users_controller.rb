# frozen_string_literal: true

# Users controller, primarily for user admin management
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy un_delete]
  before_action :require_admin, only: %i[index update destroy un_delete]
  before_action :require_user_or_admin, only: :update
  before_action :final_admin, only: :update

  def index
    @users = User.all.order(:email).page(params[:page])
  end

  def update
    if params[:user][:role].present?
      if params[:user][:role] == 'user'
        @user.remove_all_roles('user')
      else
        @user.add_role(params[:user][:role])
      end
    else
      @user.update_attributes user_params
    end
    redirect_to users_path
  end

  def destroy
    @user.update_attributes disabled: true
    redirect_to users_path
  end

  def un_delete
    @user.update_attributes disabled: false
    redirect_to users_path
  end

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
    params.require(:user).permit(:email, :job_title, :first_name, :last_name, :phone_number, :visn, :skip_va_validation)
  end
end
