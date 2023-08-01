class PageComponentsController < ApplicationController
  before_action :set_page_component, only: [:move_to_top]

  # PATCH /page_components/1/move_to_top
  def move_to_top
    @page_component.move_to_top
    render json: { success: true }
  end

  private

  def set_page_component
    @page_component = PageComponent.find(params[:id])
  end
end