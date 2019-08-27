# frozen_string_literal: true

class CreateSurveyResultFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_result_files do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :survey_result_files, :attachment
  end
end
