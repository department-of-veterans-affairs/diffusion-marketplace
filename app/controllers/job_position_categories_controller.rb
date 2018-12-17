class JobPositionCategoriesController < ApplicationController
  before_action :set_job_position_category, only: [:show, :edit, :update, :destroy]

  # GET /job_position_categories
  # GET /job_position_categories.json
  def index
    @job_position_categories = JobPositionCategory.all
  end

  # GET /job_position_categories/1
  # GET /job_position_categories/1.json
  def show
  end

  # GET /job_position_categories/new
  def new
    @job_position_category = JobPositionCategory.new
  end

  # GET /job_position_categories/1/edit
  def edit
  end

  # POST /job_position_categories
  # POST /job_position_categories.json
  def create
    @job_position_category = JobPositionCategory.new(job_position_category_params)

    respond_to do |format|
      if @job_position_category.save
        format.html { redirect_to @job_position_category, notice: 'Job position category was successfully created.' }
        format.json { render :show, status: :created, location: @job_position_category }
      else
        format.html { render :new }
        format.json { render json: @job_position_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_position_categories/1
  # PATCH/PUT /job_position_categories/1.json
  def update
    respond_to do |format|
      if @job_position_category.update(job_position_category_params)
        format.html { redirect_to @job_position_category, notice: 'Job position category was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_position_category }
      else
        format.html { render :edit }
        format.json { render json: @job_position_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_position_categories/1
  # DELETE /job_position_categories/1.json
  def destroy
    @job_position_category.destroy
    respond_to do |format|
      format.html { redirect_to job_position_categories_url, notice: 'Job position category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_position_category
      @job_position_category = JobPositionCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_position_category_params
      params.require(:job_position_category).permit(:name, :short_name, :description, :position, :parent_category_id)
    end
end
