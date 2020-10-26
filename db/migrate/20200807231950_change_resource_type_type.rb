class ChangeResourceTypeType < ActiveRecord::Migration[5.2]
  def change
    remove_column :practice_problem_resources, :resource_type
    remove_column :practice_solution_resources, :resource_type
    remove_column :practice_results_resources, :resource_type
    remove_column :practice_multimedia, :resource_type

    add_column :practice_problem_resources, :resource_type, :integer, default: 0
    add_column :practice_solution_resources, :resource_type, :integer, default: 0
    add_column :practice_results_resources, :resource_type, :integer, default: 0
    add_column :practice_multimedia, :resource_type, :integer, default: 0
  end
end
