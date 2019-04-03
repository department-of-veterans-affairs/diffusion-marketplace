class CategoriesController < ApplicationController
  before_action :set_impact_category, only: [:show, :edit, :update, :destroy]

  # GET /impact_categories
  # GET /impact_categories.json
  def index
    @categories = Category.all
  end

  # GET /impact_categories/1
  # GET /impact_categories/1.json
  def show
  end

  # GET /impact_categories/new
  def new
    @category = Category.new
  end

  # GET /impact_categories/1/edit
  def edit
  end

  # POST /impact_categories
  # POST /impact_categories.json
  def create
    @category = Category.new(impact_category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Impact category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /impact_categories/1
  # PATCH/PUT /impact_categories/1.json
  def update
    respond_to do |format|
      if @category.update(impact_category_params)
        format.html { redirect_to @category, notice: 'Impact category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /impact_categories/1
  # DELETE /impact_categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Impact category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_impact_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def impact_category_params
      params.require(:category).permit(:name, :short_name, :description, :position, :parent_category_id)
    end
end
