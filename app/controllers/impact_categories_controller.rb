class ImpactCategoriesController < ApplicationController
  before_action :set_impact_category, only: [:show, :edit, :update, :destroy]

  # GET /impact_categories
  # GET /impact_categories.json
  def index
    @impact_categories = ImpactCategory.all
  end

  # GET /impact_categories/1
  # GET /impact_categories/1.json
  def show
  end

  # GET /impact_categories/new
  def new
    @impact_category = ImpactCategory.new
  end

  # GET /impact_categories/1/edit
  def edit
  end

  # POST /impact_categories
  # POST /impact_categories.json
  def create
    @impact_category = ImpactCategory.new(impact_category_params)

    respond_to do |format|
      if @impact_category.save
        format.html { redirect_to @impact_category, notice: 'Impact category was successfully created.' }
        format.json { render :show, status: :created, location: @impact_category }
      else
        format.html { render :new }
        format.json { render json: @impact_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /impact_categories/1
  # PATCH/PUT /impact_categories/1.json
  def update
    respond_to do |format|
      if @impact_category.update(impact_category_params)
        format.html { redirect_to @impact_category, notice: 'Impact category was successfully updated.' }
        format.json { render :show, status: :ok, location: @impact_category }
      else
        format.html { render :edit }
        format.json { render json: @impact_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /impact_categories/1
  # DELETE /impact_categories/1.json
  def destroy
    @impact_category.destroy
    respond_to do |format|
      format.html { redirect_to impact_categories_url, notice: 'Impact category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_impact_category
      @impact_category = ImpactCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def impact_category_params
      params.require(:impact_category).permit(:name, :short_name, :description, :position, :parent_category_id)
    end
end
