class AddPositionToPracticeResources  < ActiveRecord::Migration[5.2]
  def change
    add_column :practice_problem_resources, :position, :integer
    add_column :practice_solution_resources, :position, :integer
    add_column :practice_results_resources, :position, :integer
    add_column :practice_multimedia, :position, :integer
    add_column :practice_testimonials, :position, :integer
  end
end