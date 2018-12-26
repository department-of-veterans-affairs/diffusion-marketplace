class ClinicalConditionsController < ApplicationController
  before_action :set_clinical_condition, only: [:show, :edit, :update, :destroy]

  # GET /clinical_conditions
  # GET /clinical_conditions.json
  def index
    @clinical_conditions = ClinicalCondition.all
  end

  # GET /clinical_conditions/1
  # GET /clinical_conditions/1.json
  def show
  end

  # GET /clinical_conditions/new
  def new
    @clinical_condition = ClinicalCondition.new
  end

  # GET /clinical_conditions/1/edit
  def edit
  end

  # POST /clinical_conditions
  # POST /clinical_conditions.json
  def create
    @clinical_condition = ClinicalCondition.new(clinical_condition_params)

    respond_to do |format|
      if @clinical_condition.save
        format.html { redirect_to @clinical_condition, notice: 'Clinical condition was successfully created.' }
        format.json { render :show, status: :created, location: @clinical_condition }
      else
        format.html { render :new }
        format.json { render json: @clinical_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clinical_conditions/1
  # PATCH/PUT /clinical_conditions/1.json
  def update
    respond_to do |format|
      if @clinical_condition.update(clinical_condition_params)
        format.html { redirect_to @clinical_condition, notice: 'Clinical condition was successfully updated.' }
        format.json { render :show, status: :ok, location: @clinical_condition }
      else
        format.html { render :edit }
        format.json { render json: @clinical_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clinical_conditions/1
  # DELETE /clinical_conditions/1.json
  def destroy
    @clinical_condition.destroy
    respond_to do |format|
      format.html { redirect_to clinical_conditions_url, notice: 'Clinical condition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clinical_condition
      @clinical_condition = ClinicalCondition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clinical_condition_params
      params.require(:clinical_condition).permit(:name, :short_name, :description, :position)
    end
end
