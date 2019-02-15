class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :un_delete]
  before_action :require_admin, except: :update
  before_action :require_user_or_admin, only: :update

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
    current_user.present? && current_user.has_role?(:admin)
  end

  def require_user_or_admin
    current_user.present? && (current_user == @user || current_user.has_role?(:admin))
  end

  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def user_params
    params.require(:user).permit(:email, :job_title, :first_name, :last_name, :phone_number, :visn, :skip_va_validation)
  end
end
