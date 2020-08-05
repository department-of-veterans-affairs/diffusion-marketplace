# frozen_string_literal: true

# Users controller, primarily for user admin management
class UsersController < ApplicationController
  include CropperUtils
  before_action :set_user, only: %i[show edit update destroy re_enable set_password]
  before_action :require_admin, only: %i[index update destroy re_enable]
  before_action :require_user_or_admin, only: :update
  before_action :final_admin, only: :update

  def index
    redirect_to root_path
  end

  def show
    @breadcrumbs = [
      { text: 'Home', path: root_path },
      { text: 'Profile'}
    ]
    @user = User.find(params[:id])
    @favorite_practices = @user&.favorite_practices || []
    @facilities_data = facilities_json #['features']
  end

  def edit_profile
    redirect_to new_user_session_path unless current_user.present?
    @breadcrumbs = [
      { text: 'Home', path: root_path },
      { text: 'Profile', path: user_path(current_user)},
      { text: 'Edit' }
    ] if current_user.present?
    @user = current_user
  end

  def update_profile
    redirect_to users_path unless current_user.present?
    @user = current_user
    if @user.update(user_params)
      if params[:user][:delete_avatar].present? && params[:user][:delete_avatar] == 'true'
        @user.update_attributes(avatar: nil)
      end

      if is_cropping?(params[:user])
        reprocess_avatar(@user, params[:user])
      end

      flash[:success] = 'You successfully updated your profile.'
      redirect_to edit_profile_path
    else
      @user.avatar = nil if @user.errors.messages.include?(:avatar)
      render 'edit_profile'
    end
  end

  def delete_photo
    if current_user.present? && current_user.avatar.present?
      user = current_user
      user.avatar = nil
      user.save
    end

    redirect_to edit_profile_path
  end

  def update
    # @user = current_user
    if params[:user][:role].present?
      if params[:user][:role] == 'user'
        @user.remove_all_roles('user')
        flash[:success] = "Basic \"user\" role assigned to \"#{@user.email}\""
      else
        @user.add_role(params[:user][:role])
        flash[:success] = "Added \"#{params[:user][:role]}\" role to user \"#{@user.email}\""
      end
      # redirect_to users_path # Add this here, but was originally not in this location
    end
    # if @user.save
    #   @user.update_attribute(:accepted_terms, true)

    #   redirect_back(fallback_location: root_path)
    # end
    redirect_to users_path
  end

  def destroy
    @user.update_attributes disabled: true
    flash[:success] = "Disabled user \"#{@user.email}\""
    redirect_to users_path
  end

  def re_enable
    @user.update_attributes disabled: false
    flash[:success] = "Re-enabled user \"#{@user.email}\""
    redirect_to users_path
  end

  def accept_terms
    if current_user.update_attribute(:accepted_terms, true)
      redirect_to root_path
    else 
      flash[:error] = 'Something went wrong. Please contact us marketplace@va.gov for assistance.'
      redirect_to terms_and_conditions_path
    end
  end

  def terms_and_conditions
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
    if User.with_role(:admin).count == 1 && @user == current_user && params[:user][:role].present? && params[:user][:role] != 'admin'
      flash[:error] = 'There must always be at least 1 admin.'
      redirect_to users_path
    end
  end

  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def user_params
    return params.require(:user).permit(:avatar, :bio) if ENV['USE_NTLM'] == 'true'
    params.require(:user).permit(:avatar, :email, :password, :password_confirmation, :job_title, :first_name, :last_name, :phone_number, :visn, :skip_va_validation, :skip_password_validation, :bio, :location, :accepted_term, :delete_avatar, :crop_x, :crop_y, :crop_w, :crop_h)
  end
end
