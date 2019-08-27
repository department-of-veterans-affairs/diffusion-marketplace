# frozen_string_literal: true

class AddVisitIdToPractice < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :ahoy_visit_id, :integer
  end
end
