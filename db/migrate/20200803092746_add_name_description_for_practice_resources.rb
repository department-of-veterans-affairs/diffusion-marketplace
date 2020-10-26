class AddNameDescriptionForPracticeResources  < ActiveRecord::Migration[5.2]
  def change
    add_column :practice_problem_resources, :name, :string
    add_column :practice_solution_resources, :name, :string
    add_column :practice_results_resources, :name, :string
    add_column :practice_multimedia, :name, :string

    add_column :practice_problem_resources, :description, :string
    add_column :practice_solution_resources, :description, :string
    add_column :practice_results_resources, :description, :string
    add_column :practice_multimedia, :description, :string
  end
end