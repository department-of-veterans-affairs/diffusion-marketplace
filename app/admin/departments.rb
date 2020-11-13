ActiveAdmin.register Department do
  batch_action :destroy, false

  permit_params :position, :name, :short_name, :description, :id

  filter :name
  filter :description

  index do
    id_column
    column :position
    column :short_name
    column :name
    column :description
    actions
  end

  controller do
    def destroy
      deleted = remove_department
      respond_to do |format|
        if deleted
          format.html { redirect_to admin_departments_path, notice: 'Department was successfully deleted.' }
        else
          format.html { redirect_to edit_admin_department_path(id: params[:id]), :flash => { :error => 'There was an error deleting your department.' }}
        end
      end
    end

    private

    def remove_department
      begin
        DepartmentPractice.where(department_id: params[:id]).map { |dp| dp.destroy! }
        Department.find(params[:id]).destroy!
        true
      rescue => e
        Rails.logger.error "remove_department error: #{e.message}"
        e
      end
    end
  end
end
