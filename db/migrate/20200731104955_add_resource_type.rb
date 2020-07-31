class AddResourceType  < ActiveRecord::Migration[5.2]
  def change
    add_column :practice_problem_resources, :resource_type, :string
    add_column :practice_solution_resources, :resource_type, :string
    add_column :practice_results_resources, :resource_type, :string
    add_column :practice_multimedia, :resource_type, :string
  end
end