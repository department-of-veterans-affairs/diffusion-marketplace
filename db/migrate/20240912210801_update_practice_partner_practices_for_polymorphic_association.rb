class UpdatePracticePartnerPracticesForPolymorphicAssociation < ActiveRecord::Migration[6.1]
  def change
    add_reference :practice_partner_practices, :innovable, polymorphic: true, index: true

    execute <<-SQL
      UPDATE practice_partner_practices
      SET innovable_id = practice_id, innovable_type = 'Practice'
      WHERE practice_id IS NOT NULL
    SQL

    remove_column :practice_partner_practices, :practice_id
  end
end
