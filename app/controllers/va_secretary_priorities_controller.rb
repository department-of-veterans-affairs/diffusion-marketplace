class VaSecretaryPrioritiesController < ApplicationController
  before_action :set_va_secretary_priority, only: [:show, :edit, :update, :destroy]

  # GET /va_secretary_priorities
  # GET /va_secretary_priorities.json
  def index
    @va_secretary_priorities = VaSecretaryPriority.all
  end

  # GET /va_secretary_priorities/1
  # GET /va_secretary_priorities/1.json
  def show
  end

  # GET /va_secretary_priorities/new
  def new
    @va_secretary_priority = VaSecretaryPriority.new
  end

  # GET /va_secretary_priorities/1/edit
  def edit
  end

  # POST /va_secretary_priorities
  # POST /va_secretary_priorities.json
  def create
    @va_secretary_priority = VaSecretaryPriority.new(va_secretary_priority_params)

    respond_to do |format|
      if @va_secretary_priority.save
        format.html { redirect_to @va_secretary_priority, notice: 'Va secretary priority was successfully created.' }
        format.json { render :show, status: :created, location: @va_secretary_priority }
      else
        format.html { render :new }
        format.json { render json: @va_secretary_priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /va_secretary_priorities/1
  # PATCH/PUT /va_secretary_priorities/1.json
  def update
    respond_to do |format|
      if @va_secretary_priority.update(va_secretary_priority_params)
        format.html { redirect_to @va_secretary_priority, notice: 'Va secretary priority was successfully updated.' }
        format.json { render :show, status: :ok, location: @va_secretary_priority }
      else
        format.html { render :edit }
        format.json { render json: @va_secretary_priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /va_secretary_priorities/1
  # DELETE /va_secretary_priorities/1.json
  def destroy
    @va_secretary_priority.destroy
    respond_to do |format|
      format.html { redirect_to va_secretary_priorities_url, notice: 'Va secretary priority was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_va_secretary_priority
      @va_secretary_priority = VaSecretaryPriority.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def va_secretary_priority_params
      params.require(:va_secretary_priority).permit(:name, :short_name, :description, :position)
    end
end
