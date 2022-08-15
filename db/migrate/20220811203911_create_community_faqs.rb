class CreateCommunityFaqs < ActiveRecord::Migration[6.0]
  def change
    create_table :community_faqs do |t|
      t.belongs_to :community, foreign_key: true
      t.text :question
      t.text :answer
      t.timestamps
    end
  end
end
