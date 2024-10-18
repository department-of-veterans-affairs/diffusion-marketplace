class AddInnovableToCategoryPractices < ActiveRecord::Migration[6.1]
  def up
    remove_foreign_key :category_practices, :practices

    add_reference :category_practices, :innovable, polymorphic: true, index: true

    execute <<-SQL
      UPDATE category_practices
      SET innovable_id = practice_id, innovable_type = 'Practice'
      WHERE practice_id IS NOT NULL
    SQL

    remove_column :category_practices, :practice_id
  end

  def down
    add_column :category_practices, :practice_id, :integer

    execute <<-SQL
      UPDATE category_practices
      SET practice_id = innovable_id
      WHERE innovable_type = 'Practice'
    SQL

    remove_reference :category_practices, :innovable, polymorphic: true
    add_foreign_key :category_practices, :practices
  end
end
