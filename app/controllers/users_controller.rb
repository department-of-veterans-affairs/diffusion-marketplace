# frozen_string_literal: true

# Users controller, primarily for user admin management
class UsersController < ApplicationController
  require 'will_paginate/array'
  include CropperUtils
  before_action :authenticate_user!, only: [:update, :edit_profile, :update_profile, :delete_photo, :destroy, :re_enable, :index]
  before_action :is_set_user, only: [:show]
  before_action :set_user, only: %i[show destroy re_enable set_password]
  before_action :set_user_for_editing, only: [:edit_profile, :update_profile, :delete_photo]
  before_action :require_user_or_admin, only: [:update, :edit_profile, :update_profile]
  before_action :require_admin, only: %i[index update destroy re_enable]
  before_action :final_admin, only: :update

  def index
    redirect_to root_path
  end

  def show
    @user = current_user
    @favorite_practices = @user&.favorite_practices || []
    @created_practices = @user.created_practices
  end

  def edit_profile
  end

  def bio
    @user = User.find_by(id: params[:id].to_i)

    if @user.nil? || !@user.granted_public_bio
      redirect_to root_path, alert: 'Bio page unavailable'
    end
  end

  def update_profile
    redirect_to root_path unless current_user.present?

    updated_params = user_params.to_h
    updated_params[:work] = {} if user_params[:work_deleted] == "true"

    if @user.update(updated_params.except(:work_deleted))
      if params[:user][:delete_avatar].present? && params[:user][:delete_avatar] == 'true'
        @user.update(avatar: nil)
      end

      if current_user == @user
        flash[:success] = 'You successfully updated your profile.'
        redirect_to edit_profile_path
      else
        flash[:success] = 'You successfully updated this user profile.'
        redirect_to admin_edit_user_profile_path(@user)
      end
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
    if params[:user][:role].present?
      if params[:user][:role] == 'user'
        @user.remove_all_roles('user')
        flash[:success] = "Basic \"user\" role assigned to \"#{@user.email}\""
      else
        @user.add_role(params[:user][:role])
        flash[:success] = "Added \"#{params[:user][:role]}\" role to user \"#{@user.email}\""
      end
    end
    redirect_to users_path
  end

  def destroy
    @user.update(disabled: true)
    flash[:success] = "Disabled user \"#{@user.email}\""
    redirect_to users_path
  end

  def re_enable
    @user.update(disabled: false)
    flash[:success] = "Re-enabled user \"#{@user.email}\""
    redirect_to users_path
  end

  def accept_terms
    if current_user.update_attribute(:accepted_terms, true)
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong. Please contact us marketplace@va.gov for assistance.'
      redirect_to root_path
    end
  end

  private

  # We only want users to view their own profile and not see other users' profiles with the other users' user id
  def is_set_user
    user_from_params = User.find(params[:id] || params[:user_id])
    if current_user.present? && user_from_params.present?
      redirect_to root_path if current_user.id != user_from_params.id
    else
      redirect_to root_path
    end
  end

  def require_admin
    unless current_user.present? && current_user.has_role?(:admin)
      redirect_to :root
    end
  end

  # This is to cover any sort of User self-editing in the future (such as profile infomation)
  def require_user_or_admin
    unless current_user.present? && (current_user == @user || current_user.has_role?(:admin))
      redirect_to root_path
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

  def set_user_for_editing
    if current_user.has_role?(:admin) && params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def user_params
    params.require(:user).permit( :accepted_term,
                                  :accolades,
                                  :alt_first_name,
                                  :alt_job_title,
                                  :alt_last_name,
                                  :avatar,
                                  :bio,
                                  :delete_avatar,
                                  :email,
                                  :first_name,
                                  :fellowship,
                                  :job_title,
                                  :last_name,
                                  :location,
                                  :password,
                                  :password_confirmation,
                                  :phone_number,
                                  :project,
                                  :skip_va_validation,
                                  :skip_password_validation,
                                  :visn,
                                  :work_deleted,
                                  work: [:text, :link]
                                )
  end
end
