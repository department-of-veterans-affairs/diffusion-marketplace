class CreatePracticeEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_emails do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :address
      t.timestamps
    end
  end
end
