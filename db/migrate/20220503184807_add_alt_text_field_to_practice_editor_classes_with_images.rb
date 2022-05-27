class AddAltTextFieldToPracticeEditorClassesWithImages < ActiveRecord::Migration[6.0]
  def change
    add_column :practices, :main_display_image_alt_text, :text
    add_column :practice_problem_resources, :image_alt_text, :text
    add_column :practice_solution_resources, :image_alt_text, :text
    add_column :practice_results_resources, :image_alt_text, :text
    add_column :practice_multimedia, :image_alt_text, :text
  end
end
