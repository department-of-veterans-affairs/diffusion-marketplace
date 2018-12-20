class VaEmployeesController < ApplicationController
  before_action :set_va_employee, only: [:show, :edit, :update, :destroy]

  # GET /va_employees
  # GET /va_employees.json
  def index
    @va_employees = VaEmployee.all
  end

  # GET /va_employees/1
  # GET /va_employees/1.json
  def show
  end

  # GET /va_employees/new
  def new
    @va_employee = VaEmployee.new
  end

  # GET /va_employees/1/edit
  def edit
  end

  # POST /va_employees
  # POST /va_employees.json
  def create
    @va_employee = VaEmployee.new(va_employee_params)

    respond_to do |format|
      if @va_employee.save
        format.html { redirect_to @va_employee, notice: 'Va employee was successfully created.' }
        format.json { render :show, status: :created, location: @va_employee }
      else
        format.html { render :new }
        format.json { render json: @va_employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /va_employees/1
  # PATCH/PUT /va_employees/1.json
  def update
    respond_to do |format|
      if @va_employee.update(va_employee_params)
        format.html { redirect_to @va_employee, notice: 'Va employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @va_employee }
      else
        format.html { render :edit }
        format.json { render json: @va_employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /va_employees/1
  # DELETE /va_employees/1.json
  def destroy
    @va_employee.destroy
    respond_to do |format|
      format.html { redirect_to va_employees_url, notice: 'Va employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_va_employee
      @va_employee = VaEmployee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def va_employee_params
      params.require(:va_employee).permit(:name, :email, :bio, :title, :position)
    end
end
