class VisnsController < ApplicationController
  before_action :set_visn, only: :show

  def index
    @visns = Visn.all
  end

  def show
  end

  private

  def set_visn
    # use find_by! in order to throw an exception if a visn with the number param does not exist
    @visn = Visn.find_by!(number: params[:number])
  end

end