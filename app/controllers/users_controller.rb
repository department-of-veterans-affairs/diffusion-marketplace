# frozen_string_literal: true

# Users controller, primarily for user admin management
class UsersController < ApplicationController
  require 'will_paginate/array'
  include CropperUtils
  before_action :is_set_user, only: [:show]
  before_action :set_user, only: %i[show edit update destroy re_enable set_password]
  before_action :require_admin, only: %i[index update destroy re_enable]
  before_action :require_user_or_admin, only: %i[update]
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
    redirect_to root_path unless current_user.present?
    @user = current_user
  end

  def update_profile
    redirect_to root_path unless current_user.present?
    @user = current_user
    if @user.update(user_params)
      if params[:user][:delete_avatar].present? && params[:user][:delete_avatar] == 'true'
        @user.update(avatar: nil)
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

  def recommended_for_you
    @user = current_user || nil
    if current_user.present?
      @pagy_type = params.keys.first.to_s

      # If a favorited practice has a nil value for the time_favorited attribute, place it at the end of the favorite_practices array
      no_time_favorite_practices = UserPractice.where(user: @user, favorited: true, time_favorited: nil).map { |up| up.practice }
      favorite_practices = UserPractice.where(user: @user, favorited: true).where.not(time_favorited: nil).order('time_favorited DESC').map { |up| up.practice }
      favorite_practices.concat(no_time_favorite_practices)

      # Create the pagy instance
      @pagy_favorite_practices, @paginated_favorite_practices = pagy_array(
          favorite_practices,
          # assigning a unique page_param allows for multiple pagy instances to be used in a single action, in case we need multiple 'Load more' sections
          page_param: 'favorite',
          items: 3,
          link_extra: "data-remote='true' class='paginated-favorite-practices-page-#{params[:favorite].nil? ? 2 : params[:favorite].to_i + 1}-link dm-button--outline-secondary margin-bottom-10 margin-top-105 width-15'"
      )

      created_practices = @user.created_practices
      @pagy_created_practices, @paginated_created_practices = pagy_array(
          created_practices,
          # assigning a unique page_param allows for multiple pagy instances to be used in a single action, in case we need multiple 'Load more' sections
          page_param: 'created',
          items: 3,
          link_extra: "data-remote='true' class='paginated-created-practices-page-#{params[:created].nil? ? 2 : params[:created].to_i + 1}-link dm-button--outline-secondary margin-bottom-10 margin-top-105 width-15'"
      )


      # Practices based on the user's location
      @practices = Practice.published_enabled_approved.includes(:practice_origin_facilities)
      @facilities_data = VaFacility.cached_va_facilities.get_relevant_attributes.order_by_station_name
      @offices_data = origin_data_json
      @user_location_practices = []

      @practices.each do |p|
        if p.facility? && p.practice_origin_facilities.any?
          p.practice_origin_facilities.each do |pof|
            origin_facility = @facilities_data.find { |f| f.id === pof.va_facility_id } || nil
            @user_location_practices << p if origin_facility.present? && origin_facility.official_station_name === @user.location
          end
        end
        # TODO: In the future, if user-locations are recorded as VISNs or Offices, we need to add them here. As of 11/7/2020, we are only using facilities.
      end
      @user_location_practices
    else
      redirect_to root_path
    end

    respond_to do |format|
      format.html
      format.js
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
    return params.require(:user).permit(:avatar, :bio) if session[:user_type] === 'ntlm'
    params.require(:user).permit(:avatar, :email, :password, :password_confirmation, :job_title, :first_name, :last_name, :phone_number, :visn, :skip_va_validation, :skip_password_validation, :bio, :location, :accepted_term, :delete_avatar, :crop_x, :crop_y, :crop_w, :crop_h)
  end
end
