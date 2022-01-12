class ClinicalResourceHubsController < ApplicationController
  before_action :set_crh, only: [:show]
  def show

  end

  private
  def set_crh
    debugger
    @visn = Visn.find_by!(number: params[:id])
    @crh = ClinicalResourceHub.find_by!(visn: @visn) if @visn.present?
  end
end