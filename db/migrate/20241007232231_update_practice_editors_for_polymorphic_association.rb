class UpdatePracticeEditorsForPolymorphicAssociation < ActiveRecord::Migration[6.1]
  def change
    add_reference :practice_editors, :innovable, polymorphic: true, index: true

    execute <<-SQL
      UPDATE practice_editors
      SET innovable_id = practice_id, innovable_type = 'Practice'
      WHERE practice_id IS NOT NULL
    SQL

    remove_column :practice_editors, :practice_id
  end
end
