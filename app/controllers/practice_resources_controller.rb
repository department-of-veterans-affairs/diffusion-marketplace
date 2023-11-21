class PracticeResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:download]
  before_action :set_practice_resource, only: [:download]

  def download
    if practice_published_approved_enabled?
      handle_enabled_practice
    elsif current_user && !practice_published_approved_enabled?
      handle_user_with_disabled_practice
    else
      unauthorized_response
    end
  end

  def download_and_redirect
  end

  private

  def set_practice_resource
    @practice = Practice.find_by(id: resource_params[:practice_id])

    if @practice
      @practice_resource =  case resource_params[:resource_type]
                            when 'PracticeResource'
                              @practice.practice_resources.find_by(id: resource_params[:id])
                            when 'PracticeProblemResource'
                              @practice.practice_problem_resources.find_by(id: resource_params[:id])
                            when 'PracticeSolutionResource'
                              @practice.practice_solution_resources.find_by(id: resource_params[:id])
                            when 'PracticeResultsResource'
                              @practice.practice_results_resources.find_by(id: resource_params[:id])
                            else
                              nil
                            end
    end

    unless @practice_resource
      render plain: "Practice or Resource not found", status: :not_found and return
    end
  end

  def resource_params
    params.permit(:practice_id, :id, :resource_type)
  end

  def handle_enabled_practice
    if @practice.is_public || current_user
      redirect_to @practice_resource.attachment_s3_presigned_url
    else
      set_download_session
      authenticate_user!
    end
  end

  def handle_user_with_disabled_practice
    if check_user_practice_permissions
      redirect_to @practice_resource.attachment_s3_presigned_url
    else
      unauthorized_response
    end
  end

  def check_user_practice_permissions
    @practice.user_id == current_user.id || current_user&.roles.any? || is_user_an_editor_for_practice(@practice, current_user)
  end

  def unauthorized_response
    respond_to do |format|
      warning = 'You are not authorized to view this content.'
      flash[:warning] = warning
      format.html { redirect_to '/', warning: warning }
      format.json { render warning: warning }
    end
  end

  def set_download_session
    session[:download_info] = {
      download_url: @practice_resource.attachment_s3_presigned_url,
      practice_path: practice_path(@practice_resource.practice),
      practice_name: @practice_resource.practice.name
    }
  end

  def practice_published_approved_enabled?
    @practice.published && @practice.approved && @practice.enabled
  end
end
