# frozen_string_literal: true

class CreateAdditionalDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :additional_documents do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :additional_documents, :attachment
  end
end
