class AddPracticeOverviewProblemSolutionResultsDescriptions  < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :overview_problem, :string
    add_column :practices, :overview_solution, :string
    add_column :practices, :overview_results, :string
  end
end