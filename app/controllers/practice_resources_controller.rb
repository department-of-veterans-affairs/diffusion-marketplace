class PracticeResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:download]
  before_action :set_practice_resource, only: [:download]

  def download
    if @practice_resource
      redirect_to @practice_resource.attachment_s3_presigned_url
    else
      render plain: "Resource not found", status: :not_found
    end
  end

  private

  def set_practice_resource
    practice = Practice.find_by(id: resource_params[:practice_id])

    if practice
      @practice_resource = case resource_params[:resource_type]
                           when 'PracticeResource'
                             practice.practice_resources.find_by(id: resource_params[:id])
                           when 'PracticeProblemResource'
                             practice.practice_problem_resources.find_by(id: resource_params[:id])
                           when 'PracticeSolutionResource'
                             practice.practice_solution_resources.find_by(id: resource_params[:id])
                           when 'PracticeResultsResource'
                             practice.practice_results_resources.find_by(id: resource_params[:id])
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
end
