# frozen_string_literal: true

class CreateDomainPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :domain_practices do |t|
      t.belongs_to :domain, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
