class AddIsMajorToPracticePartners < ActiveRecord::Migration[5.2]
  def change
    add_column :practice_partners, :is_major, :boolean, default: false
  end
end
