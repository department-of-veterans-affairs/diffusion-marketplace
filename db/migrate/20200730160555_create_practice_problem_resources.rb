class CreatePracticeProblemResources < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_problem_resources do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :link_url
      t.timestamps
    end
    add_attachment :practice_problem_resources, :attachment
  end
end